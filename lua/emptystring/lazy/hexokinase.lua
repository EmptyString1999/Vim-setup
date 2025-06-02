-- show colors of highlighed hex values
return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup()
	end,
}
