#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if command -v tmux >/dev/null 2>&1; then
	[ -z "$TMUX" ] && { tmux attach-session -t default || tmux new-session -s default; }
fi


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
export GBROWSER=firefox-esr
if command -v xiwi >/dev/null 2>&1; then
    export TERMINAL="xiwi $TERMINAL"
    export READER="xiwi $READER"
    export VIDEOPLAYER="xiwi $VIDEOPLAYER"
    export GBROWSER="xiwi $GBROWSER"
fi

export HISTFILE=~/.command_line_history
export SAVEHIST=200000000
export HISTSIZE=20000000000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="df*:free*:&:ls:[bf]g:history:exit"
export WLAN_INTERFACE=wlan0
export LESS='-R -g -w'
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export WORKON_HOME=$HOME/.py_workspace
export SCRIPT_FOLDER="$HOME/.config/scripts"
#export DISTRO=$(cat /etc/os-release | grep ID | head -n 1 | cut -d= -f2)
#export DISTRO=${DISTRO:-debian}
export TZ="Europe/Warsaw"
export LANG="en_UK.UTF-8"
export LANGUAGE="en_UK.UTF-8"
export LC_ALL="en_UK.UTF-8"


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir —color=auto'
    alias vdir='vdir —color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


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
[ ! -d ~/Documents ]                    && mkdir ~/Documents    || echo "Documents already exist"
[ ! -d ~/Downloads ]                    && mkdir ~/Downloads    || echo "Downloads already exist"
[ ! -d ~/Music ]                        && mkdir ~/Music        || echo "Music already exist"
[ ! -d ~/Pictures ]                     && mkdir ~/Pictures     || echo "Pictures already exist"
[ ! -d ~/Videos ]                       && mkdir ~/Videos       || echo "Videos already exist"
[ ! -d "$WORKON_HOME" ]                 && mkdir "$WORKON_HOME" || echo "Python ENV home already exist"
[ -f ~/.bash_prompt ]                   && source ~/.bash_prompt
[ -f ~/.aliasrc ]                       && source ~/.aliasrc
[ -f ~/.fzf.bash ]                      && source ~/.fzf.bash
[ -f ~/.config/broot/launcher/bash/br ] && source ~/.config/broot/launcher/bash/br
