#!/bin/bash

VIMRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# this script lives at VIMRC_DIR/setup
VIMRC_DIR="$(dirname "$VIMRC_DIR")"

# variables for inside
DOTVIM_DIR="$VIMRC_DIR/vim"

error() {
	echo "ERROR: $*"
	exit 1
}

echo "setting up vimrc symlinks"
cd "$HOME" || error "could not cd to $HOME, bailing"

# setup .vim dir symlink for all of the configs & plugins
if ! test -e ~/.vim; then 
	# new & clean - ALL MINE!
    ln -vs "$DOTVIM_DIR" ~/.vim || error "failed to link $HOME/.vim"
elif test ~/.vim -ef "$DOTVIM_DIR"; then
	# reuse case
	echo ".vim already set to $VIMRC_DIR, reusing"
else
	# leaving alone to prevent messing up something I don't understand
	error "You have a .vim directory, this confuses me - please cleanup and retry"
fi

# setup .vimrc to pull in our config
if ! test -e ~/.vimrc; then
	# use path to where we symlinked, no need to use initial dir here
	ln -s ~/.vim/vimrc ~/.vimrc || error "failed to link $HOME/.vimrc"
elif test ~/.vimrc -ef ~/.vim/vimrc; then
	echo "Found exiting .vimrc symlink pointing to sane location, reusing"
else
    error "You have a .vimrc, this confuses me - please cleanup and retry"
fi
	
echo "Setting up Plugings"
cd "$VIMRC_DIR" || error "could not cd back to $VIMRC_DIR"
git submodule init
git submodule update

echo "Setup complete! WINNING!"
