require("mason").setup()
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
	-- mason registry package names, not nvim-lspconfig server names. The
	-- lspconfig spellings (eslint, lua_ls, ts_ls, jsonls, yamlls) only resolve
	-- through mason-lspconfig's translation table, which is not guaranteed to
	-- be loaded when run_on_start fires at VimEnter. On a cold start the
	-- lookup raises `Cannot find package "eslint"` and that error aborts the
	-- whole list, so every entry after it silently never installs.
	ensure_installed = {
		"stylua",
		"prettierd",
		"eslint-lsp",
		"lua-language-server",
		"tailwindcss-language-server",
		"typescript-language-server",
		"gopls",
		"sqls",
		"json-lsp",
		"yaml-language-server",
		"biome",
	},
	auto_update = false,
	run_on_start = true,
})

require("workspace-diagnostics").setup()

vim.api.nvim_create_autocmd(
	"LspAttach",
	{ --  Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client then
				if client:supports_method("workspace/diagnostic", ev.buf) then
					vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
				else
					require("workspace-diagnostics").populate_workspace_diagnostics(client, ev.buf)
				end
			end

			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>

			local opts = function(desc)
				return { buffer = ev.buf, silent = true, desc = desc }
			end
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts("Go to definition"))
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts("Go to implementation"))
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts("Find references"))

			vim.keymap.set({ "n", "v" }, "<leader>ca", function()
				require("tiny-code-action").code_action({
					filter = function(action)
						return not action.disabled
					end,
				})
			end, opts("Code action"))


			-- Personal scheme: gd/gD plus the nvim 0.11 builtin gr*/gO lhs,
			-- rebound to telescope pickers for a better UI than the default
			-- quickfix. grn (rename) and gra (code action) stay on the builtins.
			local tel = function(picker)
				return function()
					require("telescope.builtin")[picker]()
				end
			end
			vim.keymap.set("n", "gd", tel("lsp_definitions"), opts("[G]oto [D]efinition"))
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))
			vim.keymap.set("n", "grr", tel("lsp_references"), opts("[G]oto [R]eferences"))
			vim.keymap.set("n", "gri", tel("lsp_implementations"), opts("[G]oto [I]mplementation"))
			vim.keymap.set("n", "grt", tel("lsp_type_definitions"), opts("[G]oto [T]ype definition"))
			vim.keymap.set("n", "gO", tel("lsp_document_symbols"), opts("Document Symbols"))
			vim.keymap.set("n", "gW", tel("lsp_dynamic_workspace_symbols"), opts("Workspace Symbols"))

			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end, opts("Show diagnostics float"))
		end,
	}
)
