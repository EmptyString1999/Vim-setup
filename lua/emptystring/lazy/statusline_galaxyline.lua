return {
	"glepnir/galaxyline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
	config = function() 
		require('emptystring.config.galaxyline')
	end,
}
