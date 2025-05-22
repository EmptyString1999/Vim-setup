return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependencies = {"MunifTanjim/nui.nvim"},
	opts = {
		showmode = true,
		notification = function(message)
			vim.notify(message, vim.log.levels.WARN)
		end,
	},
}
