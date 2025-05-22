return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
	keys = {
		{
			"<leader>fp",
			function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
			desc = "Find Plugin File",
		},
		{
			"<leader>ff",
			function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end,
			desc = "Find File",
		},
		{
			"<leader>fg",
			function() require("telescope.builtin").live_grep() end,
			desc = "Live Grep",
		},
		{
			"<leader>fb",
			function() require("telescope.builtin").buffers() end,
			desc = "Buffers",
		},
		{
			"<leader>fh",
			function() require("telescope.builtin").help_tags() end,
			desc = "Help Tags",
		},
		{
			"<leader>fr",
			function() require("telescope.builtin").oldfiles() end,
			desc = "Recent Files",
		},
	}
}
