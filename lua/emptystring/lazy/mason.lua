return {
	{
		"williamboman/mason.nvim",
		build = function()
			-- run only if the command exists, and don’t hard-fail
			pcall(vim.cmd, "MasonUpdate")
		end,
	},
	{ "williamboman/mason-lspconfig.nvim" },
}
