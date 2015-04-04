"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Enable filetype plugins
filetype plugin on
filetype indent on

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Reload configuration on change
augroup myvimrc
    au!
    au BufWritePost .vimrc,marcelo.vim so $MYVIMRC
augroup END

" Show line numbers. Toggle with <F2>
set number
nmap <F2> :set number!<CR>

" Disable line wrapping. Toggle with <F3>
set nowrap
nmap <F3> :set wrap!<CR>

" Set working directory to the current file
set autochdir

" Autocomplete with CTRL-Space
imap <C-Space> <C-x><C-u>

" Make the current Windows 80 characters width
set winwidth=84

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast saving: ,w
map <leader>w :w!<cr>

" Write and exit
map <leader>x :wq<cr>

" Copy/paste from/to clipboard with <CTRL+V>
map <C-v> <Esc>"+gp
map! <C-v> <Esc>"+gp
vmap <C-c> "+y
set pastetoggle=<F4>

" Save all and run make with ,m
map <leader>m :wa<cr>:make<cr>

" Remap Keys
map <F5> :!php -l %<CR>

" Trim trailing spaces
autocmd BufWritePre * :%s/\s\+$//e


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase
set hlsearch
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 	" Chau chau chau... chauuuuuuuu!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" 256 colors
set t_Co=256

" Color scheme
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
set background=dark
"colorscheme solarized

colorscheme marcelo
if has("gui_running")
    set guifont=Ubuntu\ Mono\ 14
endif

" Highlight current line
set cursorline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GVim configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
    set guioptions-=T   " Remove toolbar
    set guioptions-=r   " Remove right-hand scrollbar
    set guioptions-=L   " Remove left-hand scrollbar
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2

set ai " Auto indent
set si " Smart indent

set nowrap
set textwidth=0
set formatoptions=qrn1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffers, splits and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-S-t> :tabnew<CR>
map <C-n> :tabnext<CR>
"map <C-d> :q<CR>
map <C-Tab> :b#<CR>
map <leader>\| :vspl<CR>
map <leader>- :spl<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>

nnoremap <silent> <C-Left> <C-w><Left>
nnoremap <silent> <C-Right> <C-w><Right>
nnoremap <silent> <C-Up> <C-w><Up>
nnoremap <silent> <C-Down> <C-w><Down>

set splitbelow
set splitright

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start scrolling slightly before the cursor reaches an edge
set scrolloff=3
set sidescrolloff=5

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
" set statusline=%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

""""""""""""""""""""""""""""""
" => Plugins configuration
""""""""""""""""""""""""""""""
"let g:clang_library_path="/usr/local/lib"
"let g:clang_library_path="/usr/lib/llvm-3.5/lib"

""""""""""""""""""""""""""""""
" => File browser with ,n
""""""""""""""""""""""""""""""
map <leader>n :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

""""""""""""""""""""""""""""""
" => Macros
""""""""""""""""""""""""""""""
" Apply macros with Q
nnoremap Q @q
vnoremap Q :norm @q<cr>

""""""""""""""""""""""""""""""
" => Macros
""""""""""""""""""""""""""""""
