"don't bother with vi compatibility
set nocompatible

" Configure Pathogen
execute pathogen#infect()

let mapleader = ','


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
filetype plugin indent on

" Highlight current line
set cursorline

" 256 colors
set t_Co=256

" Color scheme
let g:solarized_termcolors=256

set background=dark
colorscheme solarized


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show line numbers. Toggle with <F2>
set number
set ruler
" Set working directory to the current file
set autochdir

set encoding=utf-8

" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2

set ai " Auto indent
set si " Smart indent

set nowrap
set textwidth=0
set formatoptions=qrn1

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Start scrolling slightly before the cursor reaches an edge
set scrolloff=3
set sidescrolloff=5


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search as you type
set incsearch
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffers, splits and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Leader>n :tabnew<cr>
map <Leader>nc :tabclose<cr>
map <Leader>nc :tabnext<cr>
map <Leader>np :tabprevious<cr>
map <leader>\| :vspl<CR>
map <leader>- :spl<CR>
nnoremap <F5> :buffers<CR>:buffer<Space>

set splitbelow
set splitright


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keyboard shortcuts
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Others
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trim trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

" Always show the status line
set laststatus=2

" yank and paste with the system clipboard
set clipboard=unnamed

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
