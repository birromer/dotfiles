#!/bin/bash
i3-msg 'workspace "1: "; append_layout ~/.i3/workspace-1.json'

#(termite &)
#(termite &)
#(termite &)
(termite -e tmux &)
(termite -e htop &)
(termite &)
(compton &)
