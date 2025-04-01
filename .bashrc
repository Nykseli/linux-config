# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make sure that commands with new lines don't get auto executed
bind 'set enable-bracketed-paste on'

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|xterm-256color) color_prompt=yes;;
esac

# If in tmux we can safely enable color
if [[ ! -z "${TMUX}" ]]; then
    color_prompt=yes
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

GIT_BRANCH=""
# if current directory has git show the current brach name
function git_branch {
    if [ -d './.git' ] || [ -f './.git' ]; then
        GIT_BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    fi

    # TODO: color
    if [ "$GIT_BRANCH" ]; then
        printf " ($GIT_BRANCH)"
    fi

}

function wps1 {
    RES=$?
    if [ $RES != 0 ]; then
        printf 'exit ('$RES') '
    fi
}

if [ "$color_prompt" = yes ]; then
    # Show only the current directory name without parent directories and git branch name if in git repo directory
    PS1='$(wps1)${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$(git_branch)\[\033[01;34m\]\$\[\033[00m\] '
    # Uncomment for long current directory (the original PS1)
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # Show only the current directory name without parent directories and git branch name if in git repo directory
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W$(git_branch)\$ '
    # Uncomment for long current directory (the original PS1)
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# If in tmux, disable bash history
if [[ ! -z "${TMUX}" ]]; then
    # set +o history
    rm /tmp/.tmpbash_history.txt.tmp &> /dev/null
    history -r /tmp/.tmpbash_history.txt.tmp
    export HISTFILE=/tmp/.tmpbash_history.txt.tmp
    # Also support better colors in tmux
    export TERM=xterm-256color
else
    # Tell a fortune if not in termux enviroment
    fortune -a|cowsay
fi

unset LS_COLORS

export EDITOR=vi
alias tree="tree --dirsfirst -C"
alias nonet="sudo unshare -n sudo -u $USER" #start program without netprivileges
alias notes="nonet code ~/Documents/my-notes"
alias pscripts="jq .scripts package.json"
alias nmake="nice -n +15 make"
alias cdtmp="cd $(mktemp -d)"
alias pmt="path-manager tui"
alias pma="path-manager add-path"
alias pmd="path-manager pwd"

# Better man pages with bat
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export MANWIDTH=80

# Copy things from a file to clip board
function clipper {
    if [[ -z $1 ]]; then
        echo Give file as an argument
        return
    fi

    if [[ ! -f $1 ]]; then
        echo Argument "'$1'" is not a file
        return
    fi

    cat $1 | xclip -sel clip
}

# Prepend the PS1 with current time (call this to enable/disable)
show_time=false
function showtime() {
    if ! $show_time; then
        PS1="\D{%H:%M:%S} $PS1"
        show_time=true
    else
        PS1=$DEF_PS1
        show_time=false
    fi
}
DEF_PS1=$PS1

function addtopath() {
    if [[ -z $1 ]]; then
        echo Give path as an argument
        return
    fi

    FULL_PWD=$(realpath $1)
    export PATH=$FULL_PWD:$PATH
}
