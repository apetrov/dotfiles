BASE_TEMPLATES=$(wildcard templates/*)
TEMPLATES := $(BASE_TEMPLATES:templates/%=%)

.PHONY: all update git_template $(TEMPLATES)

all: update git_template $(TEMPLATES)

$(TEMPLATES):
	rm -rf $(HOME)/.$@
	ln $(PWD)/templates/$@ $(HOME)/.$@

git_template:
	rm -rf $(HOME)/$@
	ln -fs $(PWD)/git-template $(HOME)/.$@

update:
	git pull


SYSTEMD_UNITS=$(patsubst systemd/%,%, $(wildcard systemd/*))
SYSTEMD_PATH=/etc/systemd/system
%.service: systemd/%.service
	echo $@
	@if [ -L $(SYSTEMD_PATH)/$@ ]; then sudo rm $(SYSTEMD_PATH)/$@; fi
	sudo ln -s $(PWD)/$< $(SYSTEMD_PATH)/$@
	sudo systemctl daemon-reload
	sudo systemctl enable $@
	sudo systemctl start $@

systemd/all: $(SYSTEMD_UNITS)
		echo $(SYSTEMD_UNITS)

systemd/home: $(SYSTEMD_UNITS)

systemd/office: autossh.service vpn.service 


.PHONY: home systemd/all $(SYSTEMD_UNITS)
