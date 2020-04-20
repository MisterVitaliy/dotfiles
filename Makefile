.PHONY: all apps touchpad help live dunst dmenu st dwm dotfiles apps vim emacs
.PHONY: essential-remove  flex-remove gamesx-remove docker-install compton-blur
.PHONY: doas-install  essentialx-install games-install geeky-install
.PHONY: python-install useless-remove geeky-remove python-remove
.PHONY: broot-install doas-remove essentialx-remove  games-remove
.PHONY: broot-remove dotfiles essential-install flex-install gamesx-install

INSTALL_DIR=$(HOME)/Documents

ESSENTIAL=bash bash-completion curl build-essential ca-certificates fdisk git wget shellcheck w3m ripgrep htop task-spooler aria2 network-manager powertop hwinfo
ESSENTIALX=mpv feh scrot zathura zathura-pdf-poppler sxhkd xautolock libnotify-bin
GEEKY=fd-find aspell aspell-en aspell-ru aspell-uk aspell-pl openssh-client ranger emacs-nox exuberant-ctags fzf sox youtube-dl pulsemixer
PYTHON=flycheck-doc pylint python-pip python3 python3-dev python3-pip python3-tk virtualenvwrapper
FLEX=bison flex-old
GAMES=cataclysm-dda-curses crawl nethack-console nethack-spoilers slashem dwarf-fortress
GAMESX=crawl-tiles cataclysm-dda-sdl nethack-x11 nethack-lisp slashem-sdl
USELESS=fish nano zsh

all: dotfiles ## install this configs

apps: essential-install essentialx-install geeky-install python-install ## install essential, essentialx, geeky and python

dotfiles: ## install this configs
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

essentialx-install: ## install graphical essential utils
	sudo apt install $(ESSENTIALX) -y
essentialx-remove: ## remove graphical essential utils
	sudo apt purge $(ESSENTIALX) -y

games-install: ## install some cool cli games
	sudo apt install $(GAMES) -y
games-remove: ## remove that cool cli games
	sudo apt purge $(GAMES) -y

gamesx-install: ## install some cool graphical games
	sudo apt install $(GAMESX) -y
gamesx-remove: ## remove that cool graphical games
	sudo apt purge $(GAMESX) -y

geeky-install: ## install geeky utils. definitely not bloat
	sudo apt install $(GEEKY) -y
geeky-remove: ## remove geeky utils
	sudo apt purge $(GEEKY) -y

python-install: ## install python
	sudo apt install $(PYTHON) -y
	pip3 install -U python-language-server[all] youtube-dl
python-remove: ## remove python
	sudo apt purge $(PYTHON) -y
python-fix: ## set default python version
	$(eval result=$(shell update-alternatives --list python | wc -l))
	@if [ $(result) -eq 0 ]; then \
		sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 2; \
		sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1; \
	fi
	sudo update-alternatives --config python

flex-install: ## install flex&bison
	sudo apt install $(FLEX) -y
flex-remove: ## remove flex&bison
	sudo apt purge $(FLEX) -y

useless-remove: ## remove useless (for me) utils
	sudo apt purge $(USELESS) -y

doas-install: flex-install ## install doas (non-BLOAT alternative to sudo)
	git clone https://github.com/slicer69/doas \
			$(INSTALL_DIR)/doas || (cd $(INSTALL_DIR)/doas && git pull)
	sudo apt install libpam0g-dev -y
	(cd $(INSTALL_DIR)/doas && sudo make && sudo make install)
	printf "permit $(USER) as root\n" | sudo tee "/usr/local/etc/doas.conf"
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

broot-install: ## install broot
	sudo wget https://dystroy.org/broot/download/x86_64-linux/broot -O /usr/local/bin/broot
	sudo chmod +x /usr/local/bin/broot
broot-remove: ## remove broot
	@if [ -f /usr/local/bin/broot ]; then \
		sudo rm /usr/local/bin/broot; \
	fi

dwm: ## install dwm tiling manager with my patches and configs
	sudo apt install libx11-dev libxft-dev libxinerama-dev -y
	git clone https://github.com/Vitalii-Ohol/dwm \
			$(INSTALL_DIR)/dwm || (cd $(INSTALL_DIR)/dwm ; git pull)
	(cd $(INSTALL_DIR)/dwm && sudo make clean install)
	sudo cp $(PWD)/.config/additional/dwm-wrapper /usr/local/bin/
	sudo cp $(PWD)/.config/additional/dwm.desktop /usr/share/xsessions/

st: ## install ST with my patches and configs
	git clone https://github.com/Vitalii-Ohol/st \
			$(INSTALL_DIR)/st || (cd $(INSTALL_DIR)/st ; git pull)
	(cd $(INSTALL_DIR)/st && sudo make clean install)

dmenu: ## install dmenu
	git clone https://git.suckless.org/dmenu \
			$(INSTALL_DIR)/dmenu || (cd $(INSTALL_DIR)/dmenu ; git pull)
	ln -sf $(PWD)/.config/additional/dmenu.h $(INSTALL_DIR)/dmenu/config.h
	(cd $(INSTALL_DIR)/dmenu && sudo make clean install)

dunst: ## install dunst
	git clone https://github.com/dunst-project/dunst \
			$(INSTALL_DIR)/dunst || (cd $(INSTALL_DIR)/dunst ; git pull)
	(cd $(INSTALL_DIR)/dunst && sudo make install)

docker: ## install gorgeous docker
	sudo apt purge docker docker-engine docker.io -y
	sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"
	sudo apt update
	sudo apt install docker-ce -y

compton-blur: ## install compton with kawase blur
	sudo apt install libx11-dev libxcomposite-dev libxdamage-dev libxfixes-dev \
		libxext-dev libxrender-dev libxrandr-dev libxinerama-dev pkg-config \
		make x11proto-dev x11-utils libpcre++-dev libconfig-dev libdrm-dev \
		libgl-dev libdbus-1-dev asciidoc libconfig9 -y
	git clone https://github.com/GabrielTenma/compton-kawase-blur \
			$(INSTALL_DIR)/compton-kawase-blur || \
			(cd $(INSTALL_DIR)/compton-kawase-blur ; git pull)
	(cd $(INSTALL_DIR)/compton-kawase-blur \
		&& make clean && make && make docs && sudo make install)
	sudo apt purge pkg-config x11proto-dev libdrm-dev asciidoc -y

i3lock-color: ## install i3lock-color fork of famous locker
	@if [ -f /usr/local/bin/i3lock ]; then \
		echo "i3lock-color already installed.."; \
	else \
		sudo apt purge i3lock i3lock-fancy -y; \
		git clone https://github.com/Raymo111/i3lock-color \
				$(INSTALL_DIR)/i3lock-color || \
				(cd $(INSTALL_DIR)/i3lock-color ; git pull); \
		sudo apt install pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev \
			libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev \
			libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev \
			libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev \
			libjpeg-dev -y; \
		(cd $(INSTALL_DIR)/i3lock-color \
			&& chmod +x build.sh && ./build.sh \
			&& sudo cp build/i3lock /usr/local/bin/); \
		sudo apt purge pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev \
			libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev \
			libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev \
			libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev \
			libjpeg-dev -y; \
	fi

betterlockscreen: i3lock-color ## install better lock screen
	@if [ -f /usr/local/bin/betterlockscreen ]; then \
		echo "betterlockscreen already installed.."; \
	else \
		sudo apt install bc -y; \
		sudo curl -o /usr/local/bin/betterlockscreen \
			https://raw.githubusercontent.com/pavanjadhaw/betterlockscreen/master/betterlockscreen \
		&& sudo chmod +x /usr/local/bin/betterlockscreen; \
	fi

mantablockscreen: i3lock-color ## install mantablockscreen
	sudo apt install imagemagick libxcb-composite0-dev -y
	git clone https://github.com/reorr/mantablockscreen \
			$(INSTALL_DIR)/mantablockscreen || \
			(cd $(INSTALL_DIR)/mantablockscreen ; git pull)
	(cd $(INSTALL_DIR)/mantablockscreen && sudo make install)

feh-blur: ## install feh-blur
	@if [ -f /usr/local/bin/feh-blur ]; then \
		echo "feh-blur already installed.."; \
	else \
		sudo apt install wmctrl graphicsmagick feh -y; \
		sudo curl -o /usr/local/bin/feh-blur \
			https://raw.githubusercontent.com/rstacruz/feh-blur-wallpaper/master/feh-blur \
		&& sudo chmod +x /usr/local/bin/feh-blur; \
	fi

rofi-next: ## install rofi (next branch)
	sudo apt install libpango1.0-dev libpangocairo-1.0-0 libcairo2-dev \
		libglib2.0-dev librsvg2-dev libstartup-notification0-dev \
		libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libxcb1-dev \
		libxcb-util0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xrm-dev \
		autoconf automake pkg-config flex libxcb-randr0-dev libxcb-xinerama0-dev \
		check -y
	git clone https://github.com/davatorium/rofi \
			$(INSTALL_DIR)/rofi-next --recursive || \
			(cd $(INSTALL_DIR)/rofi-next ; git pull \
			&& git submodule update --init)
	(cd $(INSTALL_DIR)/rofi-next && autoreconf -i; mkdir -p build; cd build/ \
		&& ../configure --disable-check && make && sudo make install)

touchpad: ## touchpad fix for my laptop
	# === TOUCHPAD ===
	mkdir -p /etc/X11/xorg.conf.d
	ln -sf $(PWD)/.config/additional/40-libinput.conf \
			/etc/X11/xorg.conf.d/40-libinput.conf

emacs: ## install emacs with doom-emacs and my configs
	git clone https://github.com/Vitalii-Ohol/doom_emacs_config \
			$(INSTALL_DIR)/doom_config \
			|| (cd $(INSTALL_DIR)/doom_config; git pull)
	(cd $(INSTALL_DIR)/doom_config && make all)

vim: ## install vim with my configs
	git clone https://github.com/Vitalii-Ohol/vim_config \
			$(INSTALL_DIR)/vim_config \
			|| (cd $(INSTALL_DIR)/vim_config; git pull)
	(cd $(INSTALL_DIR)/vim_config && make all)

help: ## this help window
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
