$(VERBOSE).SILENT:

SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help

$(shell chmod +x ./macmake/*.sh)

CYAN := \033[0;36m
NC := \033[0m

help:
	grep -E '^[a-zA-Z_-]+:[ \t]+.*?# .*$$' $(MAKEFILE_LIST) | sort | awk -F ':.*?# ' '{printf "  ${CYAN}%-24s${NC}\t%s\n", $$1, $$2}'

i: install # alias for install

install: # copy Makefile from macmake project to home dir
	# exit if run from homedir
	if [ "$(PWD)" = "$(HOME)" ]; then echo "Run only from project dir"; exit 1; fi
	if ! cmp -s $(PWD)/Makefile ~/Makefile; then cp ~/Makefile ~/Makefile.$(shell date +%Y%m%d%H%M%S).bak; fi
	if [ -d ~/macmake ]; then chmod -R +w ~/macmake; fi
	cp -r $(PWD)/macmake ~
	chmod -R -w ~/macmake
	ln -sf $(PWD)/Makefile ~/Makefile

base-auth-gen: # generate htpasswd. Usage: make base-auth-gen u=username
	if ! command -v htpasswd &> /dev/null; then echo "htpasswd not found"; exit 1; fi
	if [ -z "$(u)" ]; then echo "set u=username as an argument"; exit 1; fi
	htpasswd -n "$(u)"

dock-hide: # permanently hide dock
	defaults write com.apple.dock autohide -bool true && killall Dock
	defaults write com.apple.dock autohide-delay -float 1000 && killall Dock
	defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock

dock-show: # show dock (default)
	defaults write com.apple.dock autohide -bool false && killall Dock
	defaults delete com.apple.dock autohide-delay && killall Dock
	defaults write com.apple.dock no-bouncing -bool FALSE && killall Dock

p: passwd-gen # alias for passwd-gen

passwd-gen: # generate password. Usage: make passwd-gen l=12 s=5 (default length: 20)
	./macmake/passwd-gen.sh "$(l)" "$(s)"

php-switch: # switch php version. Usage: make php-switch v=8.3
	if [ -z "$(v)" ]; then echo "set v=php_version as an argument"; exit 1; fi
	./macmake/php-switch.sh $(v)

exit-if-run-from-homedir:
	if [ "$(PWD)" = "$(HOME)" ]; then echo "Run only from project dir"; exit 1; fi

kill-by-port:
	if [ -z "$(p)" ]; then echo "set p=port as an argument"; exit 1; fi
	./macmake/kill-by-port.sh $(p)

test-passwd-gen: exit-if-run-from-homedir # run tests for passwd-gen
	tests/passwd-gen.test.sh
