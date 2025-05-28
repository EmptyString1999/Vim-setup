vim.g.mapleader = " " -- Set leader key before lazy

require("emptystring.lazy_init")
require("emptystring.scripts.floaterminal")

vim.keymap.set("n", "<leader>xp", ":w | !python3 %<CR>")

vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.opt["number"] = true
vim.opt["relativenumber"] = true
vim.opt["wrap"] = false
