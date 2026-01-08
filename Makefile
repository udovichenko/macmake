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

adminer-run:
	./macmake/adminer.sh run

adminer-update:
	./macmake/adminer.sh update

adminer-stop:
	./macmake/adminer.sh stop

base-auth-gen: # generate htpasswd. Usage: make base-auth-gen u=username
	if ! command -v htpasswd &> /dev/null; then echo "htpasswd not found"; exit 1; fi
	if [ -z "$(u)" ]; then echo "set u=username as an argument"; exit 1; fi
	htpasswd -n "$(u)"

brew-upgrade: # upgrade brew packages
	./macmake/brew-upgrade.sh

calc: # calculate responsive CSS value. Usage: make calc v=10,20,380,1440 or make calc v=16,24
	if [ -z "$(v)" ]; then echo "Usage: make calc v=size1,size2[,breakpoint1,breakpoint2]"; exit 1; fi
	OUTPUT=$$(node ./macmake/calc.js "$(v)"); \
	echo "$$OUTPUT"; \
	echo "$$OUTPUT" | pbcopy

calc-limit: # calculate responsive CSS value with max limit. Usage: make calc-limit v=100,150,380,1440
	if [ -z "$(v)" ]; then echo "Usage: make calc-limit v=size1,size2[,breakpoint1,breakpoint2]"; exit 1; fi
	OUTPUT=$$(node ./macmake/calc-limit.js "$(v)"); \
	echo "$$OUTPUT"; \
	echo "$$OUTPUT" | pbcopy

clean-annas-filenames: # clean filenames from specific patterns. Usage: make clean-annas-filenames d=path/to/dir
	if [ -z "$(d)" ]; then echo "set d=directory_path as an argument"; exit 1; fi
	./macmake/clean-annas-filenames.sh "$(d)"

dock-hide: # permanently hide dock
	defaults write com.apple.dock autohide -bool true && killall Dock
	defaults write com.apple.dock autohide-delay -float 1000 && killall Dock
	defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock

dock-show: # show dock (default)
	defaults write com.apple.dock autohide -bool false && killall Dock
	defaults delete com.apple.dock autohide-delay && killall Dock
	defaults write com.apple.dock no-bouncing -bool FALSE && killall Dock

mysql-create: # create mysql database
	./macmake/mysql.sh create

p: passwd-gen # alias for passwd-gen

passwd-gen: # generate password. Usage: make passwd-gen l=12 s=5 (default length: 20)
	./macmake/passwd-gen.sh "$(l)" "$(s)"

php-switch: # switch php version. Usage: make php-switch v=8.3
	if [ -z "$(v)" ]; then echo "set v=php_version as an argument"; exit 1; fi
	./macmake/php-switch.sh $(v)

rmhist: # remove a command from zsh history. Usage: make rmhist c="<command>"
	if [ -z "$(c)" ]; then echo "set c=\"<command>\" as an argument"; exit 1; fi
	./macmake/rmhist.sh "$(c)"

rmhist-dry: # dry run for rmhist. Usage: make rmhist-dry c="<command>"
	if [ -z "$(c)" ]; then echo "set c=\"<command>\" as an argument"; exit 1; fi
	./macmake/rmhist.sh "$(c)" --dry-run

exit-if-run-from-homedir:
	if [ "$(PWD)" = "$(HOME)" ]; then echo "Run only from project dir"; exit 1; fi

kill-by-port:
	if [ -z "$(p)" ]; then echo "set p=port as an argument"; exit 1; fi
	./macmake/kill-by-port.sh $(p)

rclone-add-yc: # add yandex cloud bucket access to rclone config
	./macmake/rclone-add-yc.sh

test-passwd-gen: exit-if-run-from-homedir # run tests for passwd-gen
	tests/passwd-gen.test.sh
