return {
	"rcarriga/nvim-notify",
	lazy = false,
	config = function()
		require('notify').setup({
			timeout = 3000,
			renderer = "minimal",
			display_function = function(msg, level, opts, hover)
				local notify = require("notify")
				if level == "ERROR" then
					notify(msg, level, opts)
				else
					notify(msg, level, opts)
				end
			end,
		})
	end
}
