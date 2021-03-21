#!/usr/bin/bash
# Check if the session exists, discarding output
tmux has-session 2>/dev/null

if [ $? != 0 ]; then
    # start session if it doesn't exist
    
    # this is broken bc of ruby
    # tmuxinator start moria

    # this is a workaround for tmuxinator being broken
    tmux new -s mining -d 'sh /home/drake/scripts/t_rex_mining/t_rex.sh; zsh'
fi

