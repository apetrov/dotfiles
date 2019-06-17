SHELL := /bin/bash


all: update clean link

update:
	git pull

clean:
	for x in $$(ls -1 templates); do \
					rm -f ~/.$$x || true; \
	done
	rm -rf ~/.git_template
	rm -rf ~/.ssh/config

dotfiles:
	for x in $$(ls -1 templates); do \
					ln  $$(pwd)/templates/$$x  ~/.$$x; \
	done

git_template:
	cp -R $$(pwd)/git-template ~/.git_template
	chmod +x ~/.git_template/hooks/*

ssh-config:
	mkdir -p ~/.ssh
	ln $$(pwd)/templates/ssh-config ~/.ssh/config

	[ ! -f ~/.ssh/secret ] && echo "" > ~/.ssh/secret

link: dotfiles git_template ssh-config
