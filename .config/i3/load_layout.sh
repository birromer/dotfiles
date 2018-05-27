#!/bin/bash
i3-msg 'workspace "1: "; append_layout ~/.i3/workspace-3.json'

(urxvt -e ranger &)
(urxvt -e htop &)
(urxvt -e sh ~/neo.sh &)
(compton &)
