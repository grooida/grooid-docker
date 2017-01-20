#!/usr/bin/env bash

######################
###### VARIABLES #####
######################

# android image prefix
IMAG_PREFIX="docker-android"

# current directory
BASE_DIR=$(dirname "$0")

# user executable binaries dir
HOME_BIN=$HOME/.bin

# file to be copied
FROM_FILE=$BASE_DIR/docker-android.sh

# destination executable script
DEST_FILE=$HOME_BIN/docker-android

echo "$IMAG_PREFIX: installing"

######################
##### INSTALLING #####
######################

if [ -d $HOME_BIN ]; then
    echo "$IMAG_PREFIX: copying script to $HOME/bin"
else
    echo "$IMAG_PREFIX: no $HOME/.bin directory found, creating it..."
    mkdir -p $HOME/.bin
fi

# copying script to destination
cp $FROM_FILE $DEST_FILE

# make script executable for the current user
echo "$IMAG_PREFIX: making script executable"
chmod +x $DEST_FILE
echo "$IMAG_PREFIX: $DEST_FILE is now available"
