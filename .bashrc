#! /usr/bin/env bash

if [ -f /Users/vamac/.bashrc.bash ]; then
    source /Users/vamac/.bashrc.bash
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
