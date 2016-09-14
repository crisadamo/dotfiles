alias py-web-server "python -m SimpleHTTPServer"
set -xU JAVA_HOME /usr/lib/jvm/java-8-oracle/

# GO ENV
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin                                                                                                                                                  
set -U fish_user_paths /usr/local/go/bin $fish_user_paths
# set -gx PATH $PATH /usr/local/go/bin
 
# Swift ENV
set -gx SWIFTPATH $HOME/swift
set -gx PATH $PATH $SWIFTPATH/usr/bin
