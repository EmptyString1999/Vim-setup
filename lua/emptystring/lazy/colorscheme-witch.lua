return {
	"sontungexpt/witch",
	priority = 1000,
	lazy = false,
	enabled = false,
	config = function(_, opts)
		require("witch").setup(opts)
	end,
}

