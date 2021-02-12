#!/bin/bash
sudo apt-get update -qq
sudo apt-get clean -qq
sudo apt-get install -qq -y build-essential tmux zsh unzip jq python3-pip

[ -f $HOME/security.tar ] && echo "Installing security" && mkdir -p security && mv security.tar security/ && cd security && tar -xf security.tar && make all

[ ! -d $HOME/.rbenv ] && git clone --quiet https://github.com/rbenv/rbenv.git ~/.rbenv

[ ! -d $HOME/.oh-my-zsh ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[ ! -d $HOME/.fzf ] && git clone --quiet --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install

[ ! -d $HOME/vimfiles ] && git clone --quiet --recursive https://github.com/apetrov/vimfiles $HOME/vimfiles && ln -s $HOME/vimfiles $HOME/.vim

[ ! -d $HOME/aws ] && cd $HOME && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip" &&  unzip awscliv2.zip && sudo ./aws/install

[ ! -d $HOME/dotfiles ] && git clone --quiet git@github.com:apetrov/dotfiles.git $HOME/dotfiles && cd $HOME/dotfiles && make all

[ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-z ] && mkdir -p $HOME/.oh-my-zsh/custom/plugins && git clone --quiet https://github.com/agkozak/zsh-z $HOME/.oh-my-zsh/custom/plugins/zsh-z

vim +BundleInstall +qall 2&> /dev/null

chsh -s $(which zsh)
