.PHONY: all apps touchpad help live dunst dmenu st dwm dotfiles

all: dotfiles suckless ## install dotfiles and suckless tools

dotfiles: ## install dotfiles
	@echo "HOME:  $$HOME";
	@echo "PWD    $$PWD";
	# === DOTFILES-DIRS ===
	@for dir in $(shell find $$PWD -type d \
			| egrep -v "(useful|.git)" \
			| sed s:"$$PWD/":: | sed 1d); do \
		mkdir -p $$HOME/$$dir; \
	done;
	# === DOTFILES-FILES ===
	@for file in $(shell find $$PWD -type f \
			| egrep -v "(.git|Makefile|setup.sh|README.md|LICENSE)" \
			| sed s:"$$PWD/"::); do \
		ln -sf $$PWD/$$file $$HOME/$$file; \
	done;
	mkdir -p $$HOME/INST

dwm: ## install dwm tiling manager
	# === DWM ===
	git clone https://git.suckless.org/dwm \
			$$HOME/INST/dwm || (cd $$HOME/INST/dwm ; git pull)
	(cd $$HOME/INST/dwm \
			&& git checkout -b corners \
			&& git apply $$PWD/.config/suckless/dwm-roundcorners-6.2.diff \
			&& git add . \
			&& git commit -m "corners" \
			&& git checkout master)
	(cd $$HOME/INST/dwm \
			&& git checkout -b gaps \
			&& git apply $$PWD/.config/suckless/dwm-fullgaps-6.2.diff \
			&& git add . \
			&& git commit -m "gaps" \
			&& git checkout master)
	ln -sf $$PWD/.config/suckless/dwm.h $$HOME/INST/dwm/config.h
	#(cd $$HOME/INST/dwm && git merge -q corners && git merge -q gaps)
	#(cd $$HOME/INST/dwm && make clean install)

st: ## install simple terminal emulator
	# === ST ===
	git clone https://git.suckless.org/st \
			$$HOME/INST/st || (cd $$HOME/INST/st ; git pull)
	(cd $$HOME/INST/st \
			&& git checkout -b alpha \
			&& git apply $$PWD)/.config/suckless/st-alpha-0.8.2.diff \
			&& git add . \
			&& git commit -m "alpha" \
			&& git checkout master \
			&& git merge alpha)
	ln -sf $$PWD/.config/suckless/st.h $$HOME/INST/st/config.h
	(cd $$HOME/INST/st && make clean install)

dmenu: ## install dmenu
	# === DMENU ===
	git clone https://git.suckless.org/dmenu \
			$$HOME/INST/dmenu || (cd $$HOME/INST/dmenu ; git pull)
	ln -sf $$PWD/.config/suckless/dmenu.h $$HOME/INST/dmenu/config.h
	(cd $$HOME/INST/dmenu && make clean install)

dunst: ## install dunst
	# === DMENU ===
	git clone https://github.com/dunst-project/dunst \
			$$HOME)/INST/dunst || (cd $$HOME/INST/dunst ; git pull)
	(cd $$HOME/INST/dunst && make install)

suckless: dwm st dmenu dunst ## install utils

touchpad: ## install settings for touchpad
	# === TOUCHPAD ===
	mkdir -p /etc/X11/xorg.conf.d
	ln -sf $$PWD/.config/40-libinput.conf \
			/etc/X11/xorg.conf.d/40-libinput.conf

live: ## install configs for grml-live
	# === LIVE ===
	ln -sf $$PWD/.config/grml/GRML_I \
			/etc/grml/fai/config/package_config/GRML_I
	ln -sf $$PWD/.config/grml/GRML_R \
			/etc/grml/fai/config/package_config/GRML_R
	ln -sf $$PWD/.config/grml/GRMLBASE_I \
			/etc/grml/fai/config/package_config/GRMLBASE
	ln -sf $$PWD/.config/grml/grml-live.local \
			/etc/grml/grml-live.local
	mkdir -p $$HOME/STRUCTURE/root/INST
	mkdir -p $$HOME/STRUCTURE/etc/systemd
	cp -r $$HOME/INST/* $$HOME/STRUCTURE/root/INST/
	cp -r $$PWD/.config/logind.conf $$HOME/STRUCTURE/etc/systemd/

emacs: ## install emacs with doom-emacs and configs
	git clone https://github.com/Vitalii-Ohol/doom_emacs_config \
			$$HOME/doom_emacs_config \
			|| (cd $$HOME/doom_emacs_config; git pull)
	(cd $$HOME/doom_emacs_config && make all)

vim: ## install vim with configs
	git clone https://github.com/Vitalii-Ohol/vim_config \
			$$HOME/vim_config || (cd $$HOME/vim_config; git pull)
	(cd $$HOME/vim_config && make all)

help: ## this help window
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
