BASE_FILES=$(wildcard files/*)
FILES := $(BASE_FILES:files/%=%)

.PHONY: all update git_template $(FILES)

all: inspect update git_template $(FILES) tmux-plugin-manager

inspect:
	@echo "BASE_FILES: $(BASE_FILES)"
	@echo "FILES: $(FILES)"

$(FILES):
	rm -rf $(HOME)/.$@
	ln -s $(PWD)/files/$@ $(HOME)/.$@

git_template:
	rm -rf $(HOME)/.$@
	ln -fsn $(PWD)/.git-template $(HOME)/.$@

tmux-plugin-manager:
	@if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm; \
	else \
		echo "TPM already installed."; \
	fi

update:
	git pull
