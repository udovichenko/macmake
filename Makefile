$(VERBOSE).SILENT:

.DEFAULT_GOAL := help
.PHONY: help

$(shell chmod +x ./make/*.sh)

CYAN := \033[0;36m
NC := \033[0m

help:
	grep -E '^[a-zA-Z_-]+:[ \t]+.*?# .*$$' $(MAKEFILE_LIST) | sort | awk -F ':.*?# ' '{printf "  ${CYAN}%-24s${NC}\t%s\n", $$1, $$2}'

install: # copy Makefile from macmake project to home dir
	# exit if run from homedir
	if [ "$(PWD)" = "$(HOME)" ]; then echo "Run only from project dir"; exit 1; fi
	if ! cmp -s $(PWD)/Makefile ~/Makefile; then cp ~/Makefile ~/Makefile.$(shell date +%Y%m%d%H%M%S).bak; fi
	chmod -R +w ~/make
	cp -r $(PWD)/make ~
	chmod -R -w ~/make
	ln -sf $(PWD)/Makefile ~/Makefile

base-auth-gen:
	if ! command -v htpasswd &> /dev/null; then echo "htpasswd not found"; exit 1; fi
	if [ -z "$(u)" ]; then echo "set u=username as an argument"; exit 1; fi
	htpasswd -n "$(u)"

dock-hide:
	defaults write com.apple.dock autohide -bool true && killall Dock
	defaults write com.apple.dock autohide-delay -float 1000 && killall Dock
	defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock

dock-show:
	defaults write com.apple.dock autohide -bool false && killall Dock
	defaults delete com.apple.dock autohide-delay && killall Dock
	defaults write com.apple.dock no-bouncing -bool FALSE && killall Dock

passwd-gen:
	openssl rand -base64 32 | sed 's|\/||g'

phpswitch: # switch php version. Usage: make phpswitch v=8.3
	if [ -z "$(v)" ]; then echo "set v=php_version as an argument"; exit 1; fi
	./make/phpswitch.sh $(v)