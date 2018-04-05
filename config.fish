source ~/.config/fish/solarized.fish

ssh-add ~/.ssh/id_rsa-grandata
ssh-add ~/.ssh/id_rsa

set -gx PATH $PATH /usr/local/opt/coreutils/libexec/gnubin
alias py-web-server "python -m SimpleHTTPServer"

# Scala
#alias scala /home/cristian/Applications/scala-2.11.8/bin/scala
#alias scalac /home/cristian/Applications/scala-2.11.8/bin/scalac

# Snel
set -Ux SNEL_LOAD_AUTO 0
#alias sneld /home/cristian/Develop/src/grandata/dpi/projects/snel/build/cli/snel

# Jenkins
set -Ux JENKINS_USER ''
set -Ux JENKINS_API_TOKEN ''

# Nexus
set -Ux NEXUS_USER ''
set -Ux NEXUS_PWD ''

# Projects
set -Ux f3_dev_module_dir '/Users/cristian/Develop/src/grandata/sun-frontend/node_modules/grandata-ui/'
set -Ux f3_dev_charts_dir '/Users/cristian/Develop/src/grandata/sun-frontend/node_modules/grandata-charts/'

# Androset
set -gx ANDROID_HOME $HOME/Library/Android/sdk
set -gx PATH $PATH $ANDROID_HOME/tools
set -gx PATH $PATH $ANDROID_HOME/platform-tools

# LD
set -gx LD_LIBRARY_PATH /usr/local/Cellar/gcc/6.2.0/lib
set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH /usr/local/lib

# GO ENV
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin
set -U fish_user_paths /usr/local/go/bin $fish_user_paths
set -gx PATH $PATH /usr/local/go/bin

# Rust ENV
set -gx PATH $PATH $HOME/.cargo/bin

# Swift ENV
# set -gx SWIFTPATH $HOME/swift
# set -gx PATH $PATH $SWIFTPATH/usr/bin
