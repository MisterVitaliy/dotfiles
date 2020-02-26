.PHONY: all apps touchpad help live dunst dmenu st dwm dotfiles

INSTALL_DIR=$(HOME)/Documents

ESSINTIAL=bash bash-completion curl build-essential ca-certificates fdisk git grep less make mawk wget sed shellcheck
GEEKY=fd-find aspell aspell-en aspell-ru aspell-uk aspell-pl openssh-client ranger w3m scrot ripgrep htop emacs-nox exuberant-ctags fzf i3
NPM=npm
PYTHON=flycheck-doc pylint python-pip python3 python3-dev python3-pip python3-tk
FLEX=bison flex-old
GAMES=cataclysm-dda-curses crawl nethack-console nethack-spoilers slashem dwarf-fortress
GAMESX=crawl-tiles cataclysm-dda-sdl nethack-x11 nethack-lisp slashem-sdl
USELESS=fish nano sudo zsh

all: dotfiles ## install dotfiles

dotfiles: ## install dotfiles
	# === DOTFILES-DIRS ===
	@for dir in $(shell find $(PWD) -type d \
			| egrep -v "(additional|.git)" \
			| sed s:"$(PWD)/":: | sed 1d); do \
		mkdir -p $(HOME)/$$dir; \
	done;
	# === DOTFILES-FILES ===
	@for file in $(shell find $(PWD) -type f \
			| egrep -v "(.git|Makefile|additional|setup.sh|README.md|LICENSE)" \
			| sed s:"$(PWD)/"::); do \
		ln -sf $(PWD)/$$file $(HOME)/$$file; \
	done;

essential-install: ## install essential utils
	sudo apt install $(ESSENTIAL) -y
essential-remove: ## remove essential utils
	sudo apt purge $(ESSENTIAL) -y

games-install: ## install some cool cli games
	sudo apt install $(GAMES) -y
games-remove: ## remove that cool cli games
	sudo apt purge $(GAMES) -y

gamesx-install: ## install some cool X games
	sudo apt install $(GAMESX) -y
gamesx-remove: ## remove that cool X games
	sudo apt purge $(GAMESX) -y

geeky-install: ## install geeky utils. definitely not bloat utils
	sudo apt install $(GEEKY) -y
geeky-remove: ## remove geeky utils
	sudo apt purge $(GEEKY) -y

python-install: ## install python
	sudo apt install $(PYTHON) -y
	sudo pip3 install -r $(PWD)/.config/additional/requirements.txt
python-remove: ## remove python
	sudo apt purge $(PYTHON) -y

flex-install: ## install flex&bison
	sudo apt install $(FLEX) -y
flex-remove: ## remove flex&bison
	sudo apt purge $(FLEX) -y

useless-remove: ## remove useless (for me) utils
	sudo apt purge $(USELESS) -y

doas-install: ## install doas (non-BLOAT alternative to sudo)
	git clone https://github.com/slicer69/doas \
			$(INSTALL_DIR)/doas || (cd $(INSTALL_DIR)/doas && git pull)
	sudo apt install libpam0g-dev -y
	(cd $(INSTALL_DIR)/doas && sudo make && sudo make install)
	printf "permit zeroring as root\n" | sudo tee "/usr/local/etc/doas.conf"
doas-remove:
	@if [ -d $(INSTALL_DIR)/doas ]; then \
		rm -r $(INSTALL_DIR)/doas; \
	fi
	@if [ -f /usr/local/bin/doas ]; then \
		sudo rm /usr/local/bin/doas; \
	fi
	@if [ -f /usr/local/etc/doas.conf ]; then \
		sudo rm /usr/local/etc/doas.conf; \
	fi

broot-install:
	sudo wget https://dystroy.org/broot/download/x86_64-linux/broot -O /usr/local/bin/broot
	sudo chmod +x /usr/local/bin/broot
broot-remove:
	@if [ -f /usr/local/bin/broot ]; then \
		sudo rm /usr/local/bin/broot; \
	fi

dwm: ## install dwm tiling manager
	# === DWM ===
	git clone https://git.suckless.org/dwm \
			$(INSTALL_DIR)/dwm || (cd $(INSTALL_DIR)/dwm ; git pull)
	ln -sf $(PWD)/.config/additional/dwm.h $(INSTALL_DIR)/dwm/config.h
	(cd $(INSTALL_DIR)/dwm && make clean install)

st: ## install simple terminal emulator
	# === ST ===
	git clone https://git.suckless.org/st \
			$(INSTALL_DIR)/st || (cd $(INSTALL_DIR)/st ; git pull)
	ln -sf $(PWD)/.config/additional/st.h $(INSTALL_DIR)/st/config.h
	(cd $(INSTALL_DIR)/st && make clean install)

dmenu: ## install dmenu
	# === DMENU ===
	git clone https://git.suckless.org/dmenu \
			$(INSTALL_DIR)/dmenu || (cd $(INSTALL_DIR)/dmenu ; git pull)
	ln -sf $(PWD)/.config/additional/dmenu.h $(INSTALL_DIR)/dmenu/config.h
	(cd $(INSTALL_DIR)/dmenu && make clean install)

dunst: ## install dunst
	# === DUNST ===
	git clone https://github.com/dunst-project/dunst \
			$(INSTALL_DIR)/dunst || (cd $(INSTALL_DIR)/dunst ; git pull)
	(cd $(INSTALL_DIR)/dunst && make install)

# suckless: dwm st dmenu ## install utils

touchpad: ## install settings for touchpad
	# === TOUCHPAD ===
	mkdir -p /etc/X11/xorg.conf.d
	ln -sf $(PWD)/.config/additional/40-libinput.conf \
			/etc/X11/xorg.conf.d/40-libinput.conf

emacs: ## install emacs with doom-emacs and configs
	git clone https://github.com/Vitalii-Ohol/doom_emacs_config \
			$(INSTALL_DIR)/doom_config \
			|| (cd $(INSTALL_DIR)/doom_config; git pull)
	(cd $(INSTALL_DIR)/doom_config && make all)

vim: ## install vim with configs
	git clone https://github.com/Vitalii-Ohol/vim_config \
			$(INSTALL_DIR)/vim_config \
			|| (cd $(INSTALL_DIR)/vim_config; git pull)
	(cd $(INSTALL_DIR)/vim_config && make all)

help: ## this help window
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


#check: PYTHON-exists
#PYTHON-exists: ; @which python > /dev/null
#mytarget: check
#.PHONY: check PYTHON-exists
