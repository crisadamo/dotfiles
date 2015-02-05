" Plugins                                                                       
call pathogen#infect()                                                          
call pathogen#helptags()                                                        
                                                                                
" Ctrlp                                                                         
" set runtimepath^=~/.vim/bundle/ctrlp.vim                                      
                                                                                
" set tags=/home/sites/php.tags                                                 
                                                                                
" Formats                                                                       
set ff=unix
syntax enable
                                                                                
" Display                                                                       
set background=dark                                                             
set colorcolumn=80                                                              
set t_Co=256                                                                    
let g:solarized_termcolors=256                                                  
                                                                                
" Make the current Windows 80 characters width                                  
set winwidth=84                                                                 
                                                                                
" Set up for GUI                                                                
if has("gui_running")                                                           
  " Linux                                                                       
  if has("gui_gtk2")                                                            
    colorscheme solarized                                                       
    " colorscheme twilight                                                      
    set guifont=Monospace\ 9                                                    
    set go-=T                                                                   
  elseif has("gui_macvim")                                                      
    " Mac                                                                       
  endif                                                                         
else                                                                            
  colorscheme solarized                                                         
endif                                                                           
                                                                                
" View rules                                                                    
set expandtab                                                                   
set tabstop=4                                                                   
set shiftwidth=4                                                                
set softtabstop=4                                                               
                                                                                
set number                                                                      
set nowrap                                                                      
set textwidth=0                                                                 
set formatoptions=qrn1                                                          
"set wrapmargin=0                                                               
                                                                                
set cmdheight=2                                                                 
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
                                                                                
set autochdir                                                                   
                                                                                
" Remap Keys                                                                    
" Test PHP Syntax                                                               
map <F5> :!php -l %<CR>                                                         
                                                                                
" Commnds                                                                       
" Trim trailing spaces                                                          
autocmd BufWritePre * :%s/\s\+$//e 
