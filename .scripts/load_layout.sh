#!/bin/bash
i3-msg 'workspace "1: "; append_layout ~/.i3/workspace-3.json'

(urxvt -e tmux && ranger &)
(urxvt -e htop &)
(urxvt &)
(compton &)
