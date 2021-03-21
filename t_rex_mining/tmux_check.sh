#!/usr/bin/bash
# Check if the session exists, discarding output
tmux has-session 2>/dev/null

if [ $? != 0 ]; then
    # start session if it doesn't exist
    tmuxinator start moria
fi

