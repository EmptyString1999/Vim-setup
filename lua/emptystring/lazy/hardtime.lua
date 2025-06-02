return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependenciej = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify"
	},
	opts = {
		-- ui should use notify
		ui = {
			notify = true,
			notify_title = "Hardtime",
			notify_timeout = 1000,
		},
	}
}
