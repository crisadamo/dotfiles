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

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle

git clone https://github.com/tomlion/vim-solidity
git clone https://github.com/derekwyatt/vim-scala
git clone https://github.com/vim-airline/vim-airline-themes
git clone https://github.com/bling/vim-airline
git clone https://github.com/airblade/vim-gitgutter
git clone https://github.com/altercation/vim-colors-solarized
git clone https://github.com/kien/ctrlp.vim
git clone https://github.com/scrooloose/syntastic
git clone https://github.com/scrooloose/nerdtree
git clone git://github.com/majutsushi/tagbar
git clone https://github.com/vim-scripts/Align
git clone https://github.com/pangloss/vim-javascript
git clone https://github.com/rking/ag.vim
git clone --depth=1 https://github.com/rust-lang/rust.vim.git ~/.vim/bundle/rust.vim
```
