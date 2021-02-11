#!/bin/bash
sudo apt update
sudo apt install -y build-essential tmux zsh
if [ -f $HOME/security.tar ] ;
then
        echo "exists"
        mkdir -p security
        mv security.tar security/
        cd security
        tar -xf security.tar
        make all
fi

#[ -f $HOME/.zshrc ] && source $HOME/.zshrc

[ ! -d $HOME/.rbenv ] && git clone https://github.com/rbenv/rbenv.git ~/.rbenv
[ ! -d $HOME/.oh-my-zsh ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[ ! -d $HOME/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
[ ! -d $HOME/vimfiles ] && git clone --recursive https://github.com/apetrov/vimfiles $HOME/vimfiles && ln -s $HOME/vimfiles $HOME/.vim

if [ ! -d $HOME/dotfiles ] ;
then
        git clone git@github.com:apetrov/dotfiles.git $HOME/dotfiles
        cd $HOME/dotfiles && make all
fi
