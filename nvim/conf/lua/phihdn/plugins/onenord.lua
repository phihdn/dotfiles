-- import comment plugin safely
local setup, onenord = pcall(require, "onenord")
if not setup then
	return
end

onenord.setup({
  theme = "dark",
  disable = {
    background = true
  }
})
