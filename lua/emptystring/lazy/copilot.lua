return {
  "github/copilot.vim",
  lazy = false,
  init = function()
    -- Keymaps and settings moved HERE (no defer needed)
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-K>", "<Plug>(copilot-previous)", { silent = true })
    vim.api.nvim_set_keymap("i", "<C-L>", "<Plug>(copilot-next)", { silent = true })
  end,
}
