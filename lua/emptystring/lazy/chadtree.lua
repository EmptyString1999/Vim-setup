return {
	"ms-jpq/chadtree",
	branch = "chad", -- Important: Specify the correct branch
	init = function()
		-- Optional: Set keybindings to toggle CHADTree
		vim.keymap.set("n", "<leader>e", "<cmd>CHADopen<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>r", function()
		local current_win = vim.api.nvim_get_current_win()
      local is_chadtree = vim.bo.filetype == "CHADTree"

      if is_chadtree then
        -- Return to previous window if in CHADtree
        vim.cmd("wincmd p")
      else
        -- Find existing CHADtree window or open it
        local found_chadtree = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_get_option(buf, "filetype") == "CHADTree" then
            vim.api.nvim_set_current_win(win)
            found_chadtree = true
            break
          end
        end

        if not found_chadtree then
          vim.cmd("CHADopen")
        end
      end
    end, { noremap = true, silent = true, desc = "Swap focus between tree/file" })	
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
