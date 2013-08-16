" Gui
" default colorscheme to use under ssh connection
colorscheme twilight256
set background=dark

if has('gui_running') && has('win32')
  set guifont=Consolas:h10
endif

syntax on

set encoding=utf-8
set fileformat=unix

" Tab rules
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
"set smarttab

" Lines
set number
"set rnu

set nowrap
"set textwidth=0
"set formatoptions=qrn1

set textwidth=0
set formatoptions+=1
set wrapmargin=0

set colorcolumn=80

" Display the row and column of the cursor in the status line
set ruler
set backspace=indent,eol,start

" Always scroll to what we're searching for
set scrolloff=3

" Automatically attempt to handle indentation
set autoindent

" Display the current mode at the bottom of the window
set showmode

" Highlight search results
set hlsearch

" Visually display matching braces
set showmatch

" Prevent goofy backup files
set nobackup

" Prevent the creation of swp files, they're just a mess
set noswapfile

"
set autochdir

" Custom commands
command DevRoot :NERDTree 
