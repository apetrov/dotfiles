#!/bin/bash
sudo apt update && sudo apt install -y build-essential tmux zsh unzip jq

[ -f $HOME/security.tar ] && echo "Installing security" && mkdir -p security && mv security.tar security/ && cd security && tar -xf security.tar && make all

[ ! -d $HOME/.rbenv ] && git clone https://github.com/rbenv/rbenv.git ~/.rbenv

[ ! -d $HOME/.oh-my-zsh ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[ ! -d $HOME/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install

[ ! -d $HOME/vimfiles ] && git clone --recursive https://github.com/apetrov/vimfiles $HOME/vimfiles && ln -s $HOME/vimfiles $HOME/.vim

[ ! -d $HOME/aws ] && cd $HOME && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip" &&  unzip awscliv2.zip && sudo ./aws/install

[ ! -d $HOME/dotfiles ] && git clone git@github.com:apetrov/dotfiles.git $HOME/dotfiles && cd $HOME/dotfiles && make all
