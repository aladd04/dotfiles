" --- FZF INTEGRATION ---
set rtp+=/opt/homebrew/opt/fzf

" --- BASIC SETTINGS ---
set nocompatible             " Don't be Vi compatible
set encoding=utf-8
set fileencoding=utf-8

set number                   " Show line numbers
set relativenumber           " Show relative line numbers
set ruler                    " Show the cursor position
set showcmd                  " Show command in the last line
set showmatch                " Show matching brackets
set wildmenu                 " Enhanced command line completion
set lazyredraw               " Don't redraw while executing macros
set ttyfast                  " Faster redraw

syntax enable                " Enable syntax highlighting

" --- INDENTATION ---
set tabstop=2                " Number of spaces a tab counts for
set shiftwidth=2             " Size of an indent
set expandtab                " Convert tabs to spaces
set smartindent              " Smart autoindenting on new lines
set autoindent

" --- SEARCH ---
set ignorecase               " Ignore case when searching
set smartcase                " ...unless uppercase is used
set incsearch                " Incremental search
set hlsearch                 " Highlight search results

" --- SYSTEM CLIPBOARD ---
set clipboard=unnamedplus    " Use system clipboard

" --- MAPPINGS ---
let mapleader=" "            " Set leader key to Space

" --- MISC ---
set mouse=a                  " Enable mouse
set updatetime=300           " Faster completion
set shortmess+=c             " Reduces auto-complete message clutter
