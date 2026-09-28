-- Background check for vim.pack plugin updates, shown in the statusline
-- (plugins/lualine.lua). vim.pack.get({ offline = false }) answers the same
-- question but blocks the UI for over a second, so this does it async:
--   1. `git fetch` every plugin in parallel (same args vim.pack uses), at
--      most once an hour so many nvim instances don't all hit the network
--   2. resolve each plugin's `version` to its target commit locally
--   3. count plugins whose target differs from the installed revision
-- Apply updates with :packupdate as usual.

local M = {}

M.count = 0

local FETCH_INTERVAL = 60 * 60 -- seconds
local stamp_file = vim.fn.stdpath("state") .. "/pack-updates-fetched"

local function git(args, cwd, on_done)
  vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }, function(res)
    on_done(res.code == 0 and vim.trim(res.stdout) or nil)
  end)
end

local function fetch_is_due()
  local stat = vim.uv.fs_stat(stamp_file)
  return not stat or os.time() - stat.mtime.sec > FETCH_INTERVAL
end

-- Resolve a plugin's version spec to the commit an update would move it to.
-- Calls back with nil when there is nothing to follow (pinned tag/commit).
local function resolve_target(plugin, on_done)
  local version, path = plugin.spec.version, plugin.path
  if version == nil then
    return git({ "rev-parse", "origin/HEAD" }, path, on_done)
  end
  if type(version) == "string" then
    -- a branch follows origin; a tag or commit hash is a pin
    return git({ "rev-parse", "--verify", "--quiet", "origin/" .. version }, path, on_done)
  end
  -- vim.VersionRange: the greatest semver tag inside the range
  git({ "tag", "--list" }, path, function(out)
    local best, best_tag
    for tag in vim.gsplit(out or "", "\n", { trimempty = true }) do
      local v = vim.version.parse(tag, { strict = true })
      if v and version:has(v) and (not best or v > best) then
        best, best_tag = v, tag
      end
    end
    if not best_tag then
      return on_done(nil)
    end
    git({ "rev-list", "-n", "1", best_tag }, path, on_done)
  end)
end

local function count_pending(plugins)
  local remaining, pending = #plugins, 0
  for _, plugin in ipairs(plugins) do
    resolve_target(plugin, function(target)
      if target and target ~= plugin.rev then
        pending = pending + 1
      end
      remaining = remaining - 1
      if remaining == 0 then
        M.count = pending
        vim.schedule(function()
          vim.cmd.redrawstatus()
        end)
      end
    end)
  end
end

function M.check()
  local plugins = vim.pack.get(nil, { info = false })
  if not fetch_is_due() then
    return count_pending(plugins)
  end
  local remaining = #plugins
  for _, plugin in ipairs(plugins) do
    git({ "fetch", "--quiet", "--tags", "--force", "--recurse-submodules=yes", "origin" }, plugin.path, function()
      remaining = remaining - 1
      if remaining == 0 then
        -- git callbacks run in a fast event: uv calls only, no vim.fn
        local fd = vim.uv.fs_open(stamp_file, "w", 420)
        if fd then
          vim.uv.fs_close(fd)
        end
        count_pending(plugins)
      end
    end)
  end
end

-- :packupdate changes installed revisions; recount once it is done. It fires
-- one PackChanged per plugin, so collapse the burst into a single recount.
local recount_queued = false
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Recount pending plugin updates",
  group = vim.api.nvim_create_augroup("phihdn-pack-updates", { clear = true }),
  callback = function()
    if recount_queued then
      return
    end
    recount_queued = true
    vim.defer_fn(function()
      recount_queued = false
      count_pending(vim.pack.get(nil, { info = false }))
    end, 1000)
  end,
})

return M
