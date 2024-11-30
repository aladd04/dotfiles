vim.g.mapleader = " " -- set leader key to space
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- should be take care of by karabiner mapping option + h/j/k/l into arrow keys
-- map("i", "<C-h>", "<Left>", { desc = "Move left" })
-- map("i", "<C-j>", "<Down>", { desc = "Move down" })
-- map("i", "<C-k>", "<Up>", { desc = "Move up" })
-- map("i", "<C-l>", "<Right>", { desc = "Move right" })

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })

map("n", "<C-n>", "<cmd>tabnew<CR>", { desc = "Open a new tab" })
map("n", "<tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<S-tab>", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<C-q>", "<cmd>tabclose<CR>", { desc = "Close current tab" })
