#!/bin/bash

# Developer home
DHOME=/home/developer

# Make sure you give proper permissions to share the following folders
EXPORTED_DIRECTORIES=".m2 .gradle .lein .scala .groovy .grails .sdkman/archives .sdkman/candidates .sbt .nvm .intellij .ssh"

# This function exposes previous folders to the docker container
function exported_directories_string {
    str=""

    for d in $EXPORTED_DIRECTORIES; do
        mkdir -p "$HOME/$d"
    done

    for d in $EXPORTED_DIRECTORIES; do
	str+="-v $HOME/$d:$DHOME/$d "
    done

    echo $str
}

docker run -ti --rm \
       -e DISPLAY=unix${DISPLAY} \
       -v $(pwd):/home/developer/ws \
       -v $HOME/.android-sdk:/home/developer/android-sdk-linux \
       -v $HOME/.android:/home/developer/.android \
       -v /etc/localtime:/etc/localtime:ro \
	   -v /dev/bus/usb:/dev/bus/usb \
       --privileged -v /dev/kvm:/dev/kvm \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       $(exported_directories_string) \
       mgg/android-dev
