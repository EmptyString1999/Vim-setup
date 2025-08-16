return {
	"neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
	lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
	dependencies = {
		-- for completion sources
		{ "ms-jpq/coq_nvim", branch = "coq" },
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },

		-- Mason for lsp servers
		{ "williamboman/mason.nvim", build = ":MasonUpdate" },
		{ "williamboman/mason-lspconfig.nvim" },

		-- lua typing hints
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
			auto_start = 'shut-up',
			clients = {lsp = {enabled = true}},
		}
	end,

	config = function()
		-- Your LSP settings here
		local lspconfig = require("lspconfig")
		local coq = require("coq")

		-- (optional) Mason bootstrap
		local ok_mason, mason = pcall(require, "mason")
		if ok_mason then
			mason.setup()
			local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")
			if ok_mlsp then
				mlsp.setup({
					ensure_installed = { "clangd", "lua_ls", "rust_analyzer" },
					automatic_installation = true,
				})
			end
		end

		vim.diagnostic.config({
			float = {
				wrap = true,
				max_width = 80,
			}
		})

		-- --------------- LSP servers ---------------
		-- Lua
		lspconfig.lua_ls.setup(coq.lsp_ensure_capabilities({
			settings = {
				Lua = {
					diagnostics = { global = {"vim"}},
				},
			},
		}))

		-- QML
		lspconfig.qmlls.setup(coq.lsp_ensure_capabilities({
			cmd = {"qmlss", "-E"}	
		}))

		-- Rust
		lspconfig.rust_analyzer.setup(coq.lsp_ensure_capabilities({
			settings = {
				["rust-analyzer"] = {
					imports = { granularity = { group = "module" }, prefix = "self" },
					cargo = { buildScripts = { enable = true } },
					procMacro = { enable = true }
				},
			},
		}))

		-- C/C++ (Windows SDK awareness via clangd)
		-- If you're building with MSVC, the query-driver helps clangd parse compile commands that invoke cl.exe.
		lspconfig.clangd.setup(coq.lsp_ensure_capabilities({
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				-- path to VS/Build Tools install, globs are also supported.
				"--query-driver=C:/Program Files/Microsoft Visual Studio/*/VC/Tools/MSVC/*/bin/Hostx64/x64/cl.exe",
			},
			-- If you're not using compile_commands.json yet, see notes below.
			-- You can also provide fallback flags here with:
			-- init_options = { fallbackFlags = { "-std=c++20" } },
		}))
	end,
}
