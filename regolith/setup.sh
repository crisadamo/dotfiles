!#/usr/bin/env bash

echo "Setting Regolith's i3..."

cp -r .Xresources.d ~/
cp .Xresources-regolith ~/

mkdir -p ~/.config/regolith/{i3,i3xrocks}
cp i3/* ~/.config/regolith/i3/
cp i3xrocks/* ~/.config/regolith/i3xrocks/

echo "Installing packages..."

apt install zsh htop net-tools vim git zip curl coreutils build-essential gcc gdb

mkdir -p ~/Develop/depot_tools

cp -r ../.vim/ $HOME
cp ../.vimrc $HOME

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle

cp ../.zshrc $HOME

