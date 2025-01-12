vim.g.mapleader = " " -- set leader key to space
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open a new tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close current tab" })

map("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Go to next buffer" })
map("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Go to previous buffer" })
map("n", "<leader>bf", "<cmd>Telescope buffers<CR>", { desc = "Search buffers" })
map("n", "<leader>bo", "<cmd>Telescope oldfiles cwd_only=true<CR>", { desc = "Search old files in directory" })

