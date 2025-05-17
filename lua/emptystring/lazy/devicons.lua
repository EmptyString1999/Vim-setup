return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				zsh = {
					icon = "",
					color = "#428850",
					name = "Zsh",
				},
			},
		})
	end,
}
