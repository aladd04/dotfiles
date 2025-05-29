-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("x", "<leader>p", '"_dP', { desc = "Better Paste", noremap = true })
map("n", "<C-u>", "<C-u>zz", { desc = "Ctrl-u and Center", noremap = true })
map("n", "<C-d>", "<C-d>zz", { desc = "Ctrl-d and Center", noremap = true })
