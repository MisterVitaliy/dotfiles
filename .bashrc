#!/bin/bash
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'


complete -cf sudo
complete -cf man


set -o vi
set complete_aliases


shopt -s cmdhist
shopt -s histverify
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dirspell direxpand
shopt -s extglob
shopt -s dotglob
shopt -s globstar
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s checkjobs
shopt -s extquote
shopt -s hostcomplete
shopt -s interactive_comments
shopt -s lastpipe
shopt -s nocasematch
shopt -s shift_verbose


export SHELL=/bin/bash
export EDITOR=emacsclient
export TBROWSER=w3m
export TERMINAL=xterm
export READER=zathura
export VIDEOPLAYER=mpv
export IMAGEVIEWER=feh
export GBROWSER=firefox-esr
if command -v xiwi >/dev/null 2>&1; then
    export TERMINAL="xiwi $TERMINAL"
    export READER="xiwi $READER"
    export VIDEOPLAYER="xiwi $VIDEOPLAYER"
    export IMAGEVIEWER="xiwi $IMAGEVIEWER"
    export GBROWSER="xiwi $GBROWSER"
fi

export HISTFILE=$HOME/.config/cl_history
export SAVEHIST=200000000
export HISTSIZE=20000000000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="df*:free*:&:ls:[bf]g:history:exit"

export WLAN_INTERFACE=wlan0
export WORKON_HOME=$HOME/.py_workspace
export PROJECT_HOME=$HOME/projects
export SCRIPT_FOLDER="$HOME/.config/scripts"

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export LESS='-R -g -w'
export LESSHISTFILE="-"
export ALSA_CONFIG_PATH="$HOME/.config/alsa/asoundrc"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export WGETRC="$HOME/.config/wget/wgetrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export CRAWL_DIR="$XDG_DATA_HOME"/crawl/
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME"/bash-completion/bash_completion
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export QT_QPA_PLATFORMTHEME="gtk2"  # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"  # Mozilla smooth scrolling/touchpads.
#export DISTRO=$(cat /etc/os-release | grep ID | head -n 1 | cut -d= -f2)
#export DISTRO=${DISTRO:-debian}
#export TZ="Europe/Warsaw"
#export LANG="en_UK.UTF-8"
#export LANGUAGE="en_UK.UTF-8"
#export LC_ALL="en_UK.UTF-8"


if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		source /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion
	elif [ -f /usr/local/etc/bash_completion ]; then
		source /usr/local/etc/bash_completion
	fi
fi
if [ -d /etc/bash_completion.d/ ]; then
	for file in /etc/bash_completion.d/* ; do
		source "$file"
	done
fi

git config --global user.email "ohol.vitaliy@gmail.com"
git config --global user.name "Vitalii-Ohol"
git config --global github.user "Vitalii-Ohol"

clear

if command -v xrandr >/dev/null 2>&1; then
	export MONITOR_ONE=$(xrandr -q | grep connected | awk 'NR==1{print $1}')
	export MONITOR_TWO=$(xrandr -q | grep connected | awk 'NR==2{print $1}')
else
	echo "XRANDR not installed..."
fi

if command -v neofetch >/dev/null 2>&1; then
	neofetch
else
	echo 'NEOFETCH not installed...'
fi

if command -v screenfetch >/dev/null 2>&1; then
	screenfetch
else
	echo 'SCREENFETCH not installed...'
fi

if command -v pfetch >/dev/null 2>&1; then
	pfetch
else
	echo 'PFETCH not installed...'
fi


[ -d "$SCRIPT_FOLDER" ]                 && export PATH="$PATH:$SCRIPT_FOLDER"
[ ! -d ~/Documents ]                    && mkdir ~/Documents     || echo "Documents already exist"
[ ! -d ~/Downloads ]                    && mkdir ~/Downloads     || echo "Downloads already exist"
[ ! -d ~/Music ]                        && mkdir ~/Music         || echo "Music already exist"
[ ! -d ~/Pictures ]                     && mkdir ~/Pictures      || echo "Pictures already exist"
[ ! -d ~/Videos ]                       && mkdir ~/Videos        || echo "Videos already exist"
[ ! -d "$WORKON_HOME" ]                 && mkdir "$WORKON_HOME"  || echo "Python ENV home already exist"
[ ! -d "$PROJECT_HOME" ]                && mkdir "$PROJECT_HOME" || echo "projecthome already exist"

[ -f $HOME/.config/promptrc ]                  && source $HOME/.config/promptrc
[ -f $HOME/.config/aliasrc ]                   && source $HOME/.config/aliasrc
[ -f $HOME/.fzf.bash ]                         && source $HOME/.fzf.bash
[ -f $HOME/.config/broot/launcher/bash/br ]    && source $HOME/.config/broot/launcher/bash/br
[ -f /usr/local/bin/virtualenvwrapper.sh ]     && source /usr/local/bin/virtualenvwrapper.sh 
[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ] && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

[ -z "$DISPLAY" ] || setxkbmap -option caps:super
