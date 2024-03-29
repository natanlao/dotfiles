" Derived from https://github.com/mathiasbynens/dotfiles
if !empty($__VIM_COLOR_SCHEME)
    set background=$__VIM_COLOR_SCHEME
else
    set background=dark
endif
colorscheme solarized

" Make Vim more useful
set nocompatible
" Disable viminfo
set viminfofile=NONE
" Disable netrwhist
let g:netrw_dirhistmax=0
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
set clipboard+=unnamedplus
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backup
set directory=~/.vim/swap
if exists("&undodir")
    set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs four spaces wide and soft by default
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown wrap tw=80
    autocmd BufNewFile,BufRead *.markdown setlocal wrap tw=80
    " Show real tabs in *.go files
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab
    autocmd BufNewFile,BufRead cpanfile setlocal filetype=perl
endif

" Auto indent
set autoindent

""" Gratefully stolen from charlesreid1/mac-dotfiles:.vimrc
filetype plugin indent on
set nofoldenable
" Disable one-second delay when pressing O
set noesckeys
set ttimeoutlen=5

" now you have to do this a second time
" (after the above lines)
set nocompatible
" http://blog.sanctum.geek.nz/vim-annoyances/
" don't break words with wrap on
set linebreak
set synmaxcol=200
set smartcase
" Ignore these extensions when autocompleting filenames
set wildignore=*.o,*.obj,*.bak,*.exe,.git,.git/*,*.pyc
