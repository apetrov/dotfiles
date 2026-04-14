BASE_FILES=$(filter-out files/quake files/quake3,$(wildcard files/*))
FILES := $(BASE_FILES:files/%=%)

.PHONY: all update git_template quake3-autoexec vkquake-config $(FILES)

all: inspect update install

inspect:
	@echo "BASE_FILES: $(BASE_FILES)"
	@echo "FILES: $(FILES)"

$(FILES):
	rm -rf $(HOME)/.$@
	ln -s $(PWD)/files/$@ $(HOME)/.$@

install: git_template $(FILES) jupyter_server_config.json tmux-plugin-manager quake3-autoexec vkquake-config

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

quake3-autoexec:
	mkdir -p "$(HOME)/Library/Application Support/Quake3"
	rm -rf "$(HOME)/Library/Application Support/Quake3/autoexec.cfg"
	ln -s "$(PWD)/files/quake3/autoexec.cfg" "$(HOME)/Library/Application Support/Quake3/autoexec.cfg"

vkquake-config:
	@[ -n "$(QUAKE_DIR)" ] || (echo "QUAKE_DIR is not set"; exit 1)
	mkdir -p "$(QUAKE_DIR)/id1"
	rm -rf "$(QUAKE_DIR)/id1/vkQuake.cfg"
	ln -s "$(PWD)/files/quake/vkQuake.cfg" "$(QUAKE_DIR)/id1/vkQuake.cfg"

Brewfile: .FORCE
	@rm -rf $@
	brew bundle dump

update-os:
	sudo softwareupdate -ia

update-appstore:
	mas upgrade

update-brew:
	: > change.log
	brew update 2>&1 | tee -a change.log
	brew upgrade 2>&1 | tee -a change.log
	brew doctor 2>&1 | tee -a change.log || true
	brew cleanup --prune=all 2>&1 | tee -a change.log

update-lazy:
	nvim --headless -c 'Lazy! update' -c 'qa' 2>&1 | tee -a change.log

summarize-changes:
	@cat change.log | uvx llm "Summarize change.log. Focus on what changed, notable upgrades, warnings, failures, and suggested follow-ups. Keep it concise."

update: update-brew Brewfile update-lazy summarize-changes update-appstore
	@echo "Done $@"

cache-purge:
	pip3.14 cache purge
	go clean -cache
	sudo log erase --all

bun-clean:
		rm -rf $(HOME)/.bun/install/cache

.FORCE:
