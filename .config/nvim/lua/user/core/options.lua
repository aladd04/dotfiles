vim.cmd("let g:netrw_liststyle = 3") -- set explorer view to tree-style

local o = vim.opt

o.mouse = "a" -- enable mouse support in all modes

o.relativenumber = true -- relative line numbers
o.number = true -- absolute line number on cursor line (when relative number is on)

o.tabstop = 2 -- tab size
o.shiftwidth = 2 -- indent size
o.softtabstop = 2 -- ensure consistency
o.expandtab = true -- make tab be spaces
o.autoindent = true -- copy indent from current line when starting new one
o.smartindent = true -- attempt to follow tab pattern in file

o.wrap = false -- disable line wrapping

o.ignorecase = true -- ignore case when searching
o.smartcase = true -- do case searching when mixed case is provided

o.cursorline = true -- highlight current cursor line

o.termguicolors = true -- fancy colors, needs modern terminal
o.background = "dark" -- force dark theme
o.signcolumn = "yes" -- show column for icons or symbols next to line numbers

o.clipboard:append("unnamedplus") -- use system clipboard

o.laststatus = 3 -- show a global status bar
o.splitright = true -- split vertical windows to the right
o.splitbelow = true -- split horizontal windows to the bottom

o.swapfile = false -- disable swapfile
