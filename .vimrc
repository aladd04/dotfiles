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

syntax enable                " Enable syntax highlighting

" --- INDENTATION ---
set tabstop=2                " Number of spaces a tab counts for
set shiftwidth=2             " Size of an indent
set expandtab                " Convert tabs to spaces
set smartindent              " Smart autoindenting on new lines
set autoindent               " Enable autoindenting

" --- SEARCH ---
set ignorecase               " Ignore case when searching
set smartcase                " ...unless uppercase is used
set incsearch                " Incremental search
set hlsearch                 " Highlight search results

" --- MISC ---
set mouse=a                  " Enable mouse

