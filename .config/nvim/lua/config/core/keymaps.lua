vim.g.mapleader = " " -- set leader key to space
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
