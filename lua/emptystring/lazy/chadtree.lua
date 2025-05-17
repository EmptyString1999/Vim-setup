return {
	"ms-jpq/chadtree",
	branch = "chad", -- Important: Specify the correct branch
	init = function()
		-- Optional: Set keybindings to toggle CHADTree
		vim.keymap.set("n", "<leader>e", "<cmd>CHADopen<cr>", { noremap = true, silent = true })
		local chadtree_settings = {
			view = {
				window_options = {
					relativenumber = true,
				},
			},
			theme = {
				icon_glyph_set = "devicons",
				text_colour_set = "nerdtree_syntax_dark",
			},
		}
		vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
	end

}
