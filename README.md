# Dotfiles


#### Installing Goto

Open the terminal and just paste this chuck of code on it and hit enter and you are done!

###### For BASH shell:
```bash
(cd $HOME && 
wget https://raw.githubusercontent.com/crisadamo/dotfiles/master/goto &&
chmod u+x goto &&
cp .bashrc .bashrc-backup &&
sed -i "1i alias goto=\". $HOME/goto \$@\"" .bashrc &&
source $HOME/.bashrc)
```

###### For FISH shell:
```bash
coming soon
```

