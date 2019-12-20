#!/usr/bin/env bash

###################################################################
echo "Fixing Avahi-daemon Network bug..."

sudo sed -i sed 's/^hosts:.*/hosts:          files dns/'


###################################################################
echo "Installing packages..."

sudo add-apt-repository universe
sudo apt update

sudo apt install -y --allow \
  exfat-fuse \
  exfat-utils \
  gparted \
  curl \
  coreutils \
  build-essential \
  gcc \
  gdb \
  net-tools \
  silversearcher-ag \
  git \
  zsh \
  zsh-syntax-highlighting \
  zsh-autosuggestions \
  xclip \
  htop \
  exuberant-ctags \
  vim \
  zip \
  rar \
  python-setuptools \
  python-dev \
  virtualenvwrapper \
  graphviz \
  vlc
  
# Cleaning up
sudo apt -f install &&
sudo apt autoremove &&
sudo apt -y autoclean &&
sudo apt -y clean


###################################################################
echo "Setting Regolith's i3..."

cp -r regolith/.Xresources.d ~/
cp regolith/.Xresources-regolith ~/

mkdir -p ~/.config/regolith/
cp -r regolith/i3/ ~/.config/regolith/
cp -r regolith/i3xrocks/ ~/.config/regolith/


###################################################################
echo "Setting vim..."

cp -r .vim/ $HOME
cp .vimrc $HOME

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/airblade/vim-gitgutter ~/.vim/bundle/vim-gitgutter
git clone https://github.com/kien/ctrlp.vim ~/.vim/bundle/ctrlp.vim
git clone https://github.com/scrooloose/syntastic ~/.vim/bundle/syntastic
git clone https://github.com/scrooloose/nerdtree ~/.vim/bundle/nerdtree
git clone https://github.com/majutsushi/tagbar ~/.vim/bundle/tagbar
git clone https://github.com/vim-scripts/Align ~/.vim/bundle/Align
git clone https://github.com/altercation/vim-colors-solarized ~/.vim/bundle/vim-colors-solarized
git clone https://github.com/rking/ag.vim ~/.vim/bundle/ag.vim
git clone --depth=1 https://github.com/rust-lang/rust.vim.git ~/.vim/bundle/rust.vim
git clone https://github.com/pangloss/vim-javascript ~/.vim/bundle/vim-javascript
git clone https://github.com/derekwyatt/vim-scala ~/.vim/bundle/vim-scala
git clone https://github.com/tomlion/vim-solidity ~/.vim/bundle/vim-solidity


###################################################################
echo "Setting zsh..."

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp .zshrc $HOME/

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zshrc

cp tmux/tmux.conf ~/.tmux.conf


###################################################################
echo "Creating common directory structure..."

mkdir -p $HOME/Applications
mkdir -p $HOME/Develop/{src,apps,test,depot_tools}
mkdir -p $HOME/Downloads/{text,media,software,src}
mkdir -p $HOME/Documents/{docs,taxes,books}
