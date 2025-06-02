return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
    	local macchiato = require("catppuccin.palettes").get_palette "macchiato"
		require("catppuccin").setup {
			highlight_overrides = {
				all = function(colors)
					return {
						-- Custom LineNr
						LineNr = {  fg = macchiato.overlay1 },
					}
				end,
			}
		}
		vim.cmd.colorscheme("catppuccin-macchiato")
		
	end		
}
