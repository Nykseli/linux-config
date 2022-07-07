#/bin/bash

set -e

# https://github.com/tmux/tmux/wiki/Advanced-Use#scripting-tmux
# In order for this to work .tmux.conf needs these settings
# set -g base-index 1
# setw -g pane-base-index 1

# TODO: create different sessions and start/attach to them based on $1 arg
session="dev"
_tmux='tmux -u'

exists=$(tmux list-sessions | grep $session || printf "")

if [ "$exists" = "" ]
then
	$_tmux new-session -d -s $session
	$_tmux rename-window -t 1 'main'
	$_tmux split-window -h -t $session
	$_tmux split-window -v -t $session:1.2
	$_tmux send-keys -t $session:1.3 'htop -p0' C-m
fi

$_tmux attach-session -t $session
