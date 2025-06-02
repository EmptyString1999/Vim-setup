return {
	"rcarriga/nvim-notify",
	lazy = false,
	priority = 100,
	config = function()
		local notify = require("notify")
		notify.setup({
			timeout = 3000,
			renderer = "minimal",
			merge_duplicates = true,
		})
		vim.notify = notify
	end
}
