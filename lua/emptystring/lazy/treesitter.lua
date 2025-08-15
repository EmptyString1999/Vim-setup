return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
	lazy = false, 
    configs.setup({
      ensure_installed = {
        "c", "cpp", "make", "cmake", "lua", "vim", "vimdoc", "javascript", "html", "css", "python", "typescript", "rust", "gdscript"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

