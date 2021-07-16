# Dotfiles


## Install

#### Shell Setup

```
brew install zsh zsh-autosuggestions zsh-syntax-highlighting


source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.zshrc
```

**Note:**
If you receive "highlighters directory not found" error message,
you may need to add the following to your .zshenv:

```export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters```


#### VIM Setup
```
brew update vim
brew install the_silver_searcher
brew install ctags

# Install Pathgen
mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/tmp && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Language Support
git clone --depth=1 https://github.com/rust-lang/rust.vim.git ~/.vim/bundle/rust.vim
git clone https://github.com/tomlion/vim-solidity ~/.vim/bundle/vim-solidity
git clone https://github.com/derekwyatt/vim-scala ~/.vim/bundle/
git clone https://github.com/pangloss/vim-javascript ~/.vim/bundle/

# Tooling
git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
git clone https://github.com/airblade/vim-gitgutter ~/.vim/bundle/vim-gitgutter
git clone https://github.com/kien/ctrlp.vim ~/.vim/bundle/ctrlp.vim
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic
git clone https://github.com/scrooloose/nerdtree ~/.vim/bundle/nerdtree
git clone git://github.com/majutsushi/tagbar ~/.vim/bundle/tagbar
git clone https://github.com/vim-scripts/Align ~/.vim/bundle/Align
git clone https://github.com/rking/ag.vim ~/.vim/bundle/ag.vim

# Color themes
git clone https://github.com/altercation/vim-colors-solarized ~/.vim/bundle/vim-colors-solarized
git clone https://github.com/kaicataldo/material.vim ~/.vim/tmp/material.vim
cp ~/.vim/tmp/material.vim/colors/* ~/.vim/colors/
cp -r ~/.vim/tmp/material.vim/autoload/airline ~/.vim/autoload/
cp -r ~/.vim/tmp/material.vim/autoload/lightline ~/.vim/autoload/

```
