# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle :compinstall filename '/home/elias/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install

[[ $- != *i* ]] && return

NC='\[\e[m\]'
ALERT="${BWhite}${On_Red}"

# List of aliases
alias c='clear;ls;echo'
alias ca='clear;ls -a;echo'
alias ..='cd ..'

# Ls command
alias ls='ls -CF --color=auto'
alias ll='ls -lisa --color=auto'
alias la='ls -a'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias grep='grep --color=auto'
alias x="exit"
alias edit="sudo nano"
alias update="yay -Syu --noconfirm"

# Set PATH so it includes user's private bin directories
PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

ls
echo

# auto-completion
autoload -U compinit
compinit

# Set PS1
PS1="%F{176}[%*] %F{75}|%n| %F{180}%~ %F{15}> "




