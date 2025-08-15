return {
	"neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
	lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
	dependencies = {
		-- for completion sources
		{ "ms-jpq/coq_nvim", branch = "coq" },
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		-- lps vim setup
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},

	init = function()
		vim.g.coq_settings = {
			auto_start = true, -- if you want to start COQ at startup
			-- Your COQ settings here
		}
	end,
	config = function()
		-- Your LSP settings here
		local lspconfig = require("lspconfig")
		local coq = require("coq")

		lspconfig.lua_ls.setup(coq.lsp_ensure_capabilities({}))
		lspconfig.qmlls.setup(coq.lsp_ensure_capabilities({
			cmd = {"qmlss", "-E"}	
		}))
		lspconfig.rust_analyzer.setup(coq.lsp_ensure_capabilities({
			settings = {
				["rust-analyzer"] = {
					imports = { granularity = { group = "module" }, prefix = "self" },
					cargo = { buildScripts = { enable = true } },
					procMacro = { enable = true }
				},
			},
		}))
		vim.diagnostic.config({
			float = {
				wrap = true,
				max_width = 80,
			}
		})
	end,
}
