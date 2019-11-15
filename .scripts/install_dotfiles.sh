#!/bin/bash

# Run this as root in order to download and copy the dotfiles to the correct places
# inpired on the one from my friend @hcpsilva

# Definitions
gitdir="~/.cfg/"
gitrepo="https://github.com/birromer/dotfiles"
gitworking="git --git-dir=$gitdir --work-tree=$HOME"

# Setup
alias dotgit="'$gitworkking'"
echo "alias dotgit='$gitworkking'" >> $HOME/.$(username $SHELL)rc
echo $gitdir >> $HOME/.gitignore

# Cloning
git clone --bare $gitrepo $gitdir
dotgit checkout -f
dotgit config --local status.showUntracketFile no # don't show untracked files cuz it would be hell

# Load aliases
source $HOME/.$(basename $SHELL)rc
