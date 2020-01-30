# YAD (Yet another dotfiles)

These are the dotfiles written or found by me, and used on everyday basis;

![Initial checks](/../screenshots/screenshots/initial.png "Initial checks")

![LS command](/../screenshots/screenshots/ls_and_git.png "LS command and GIT status in prompt")

They consists of:
  * Some useful scripts located at `.config/scripts`
  * Settings for:
    * vim
    * tmux
    * bash prompt
    * sxhkd
    * urxvt
    * dunst
    * htop
    * nano
    * rofi
  * Install scripts and configs for:
    * dunst `make dunst`
    * dwm `make dwm`
    * dmenu `make dmenu`
    * st `make st`
  * Bunch of fancy aliases and scripts at `.aliasrc`
  * Customized colorful bash prompt at `.bash_prompt`

## Installing
```
git clone https://github.com/MisterVitaliy/dotfiles
cd dotfiles
make dotfiles
```
Sctipt instead of moving all files to home directory create symlinks.
**CAUTION: installation of this dotfiles will remove your files with configs without ability to restore it**

Additionally ypu need to write `:PlugInstall` inside **vim** to install all shiny plugins
![Configured vim](/../screenshots/screenshots/vim.png "Configured VIM in action")

*`make help` can be used to find other options*
