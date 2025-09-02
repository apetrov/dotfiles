BASE_FILES=$(wildcard files/*)
FILES := $(BASE_FILES:files/%=%)

.PHONY: all update git_template $(FILES)

all: inspect update install

inspect:
	@echo "BASE_FILES: $(BASE_FILES)"
	@echo "FILES: $(FILES)"

$(FILES):
	rm -rf $(HOME)/.$@
	ln -s $(PWD)/files/$@ $(HOME)/.$@

install: git_template $(FILES) jupyter_server_config.json tmux-plugin-manager

git_template:
	rm -rf $(HOME)/.$@
	ln -fsn $(PWD)/.git-template $(HOME)/.$@

tmux-plugin-manager:
	mkdir -p $(HOME)/.tmux/plugins
	@if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm; \
	else \
		echo "TPM already installed."; \
	fi

jupyter_server_config.json:
	mkdir -p $(HOME)/.jupyter
	rm -rf $(HOME)/.jupyter/$@
	ln -s $(PWD)/jupyter/$@ $(HOME)/.jupyter/$@

update:
	git pull

Brewfile: .FORCE
	@rm -rf $@
	brew bundle dump

.FORCE:
