vim.cmd("let g:netrw_liststyle = 3") -- set explorer view to tree-style

vim.opt.relativenumber = true -- relative line numbers
vim.opt.number = true -- absolute line number on cursor line (when relative number is on)

vim.opt.tabstop = 2 -- tab size
vim.opt.shiftwidth = 2 -- indent size
vim.opt.expandtab = true -- make tab be spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

vim.opt.wrap = false -- disable line wrapping

vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- do case searching when mixed case is provided

vim.opt.cursorline = true -- highlight current cursor line

vim.opt.termguicolors = true -- fancy colors, needs modern terminal
vim.opt.background = "dark" -- force dark theme
vim.opt.signcolumn = "yes" -- show column for icons or symbols next to line numbers

vim.opt.clipboard:append("unnamedplus") -- use system clipboard

vim.opt.splitright = true -- split vertical windows to the right
vim.opt.splitbelow = true -- split horizontal windows to the bottom

vim.opt.swapfile = false -- disable swapfile
