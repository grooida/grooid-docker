#!/bin/bash
cd `dirname $0`

IMAG_PREFIX="docker-android"

##########################
### SHARED DIRECTORIES ###
##########################

ANDROID_SDK_HOME=$HOME/.android-sdk
ANDROID_AVD_HOME=$HOME/.android

if [ -d $ANDROID_SDK_HOME ]; then
    echo "$IMAG_PREFIX: $ANDROID_SDK_HOME found!"
else
    echo "$IMAG_PREFIX: $ANDROID_SDK_HOME not found...creating"
    mkdir -p $ANDROID_SDK_HOME
fi

if [ -d $ANDROID_AVD_HOME ]; then
    echo "$IMAG_PREFIX: $ANDROID_AVD_HOME found!"
else
    echo "$IMAG_PREFIX: $ANDROID_AVD_HOME not found...creating"
    mkdir -p $ANDROID_AVD_HOME
fi

##########################
### SYSTEM PERMISSIONS ###
##########################

# Select uid/gid of developer, kvm and video
DEV=`whoami`
DEV_UID=`egrep ^$DEV /etc/passwd|cut -d':' -f3`
DEV_GID=`egrep ^$DEV /etc/passwd|cut -d':' -f4`
KVM_GID=`egrep ^kvm /etc/group|cut -d':' -f3`
VIDEO_GID=`egrep ^video /etc/group|cut -d':' -f3`

if [ "x$KVM_GID" == "x" ] ; then
  echo "$IMAG_PREFIX: You do not have kvm group in your system, install qemu-kvm or equivalent"
  echo "$IMAG_PREFIX: Cancelled"
  exit 1
fi

if [ "x$VIDEO_GID" == "x" ] ; then
  echo "$IMAG_PREFIX: You do not have video group in your system, you will not be able to run emulator in Android Studio"
  echo "$IMAG_PREFIX: Cancelled"
  exit 1
fi

echo "$IMAG_PREFIX: In your host system, the gids of the video,kvm groups are respectively $VIDEO_GID,$KVM_GID"
echo "$IMAG_PREFIX: Your username is `whoami` with uid=$DEV_UID and gid=$DEV_GID"
echo "$IMAG_PREFIX: Do you want to change uid,gid? [YES/no]"
read YESNO

if [ "x$YESNO" == "xYES" ] ; then
  echo "$IMAG_PREFIX: Enter desired developer uid: "
  read DEV_UID
  echo "$IMAG_PREFIX: Enter desired developer gid: "
  read DEV_GID
fi

UIDS_GIDS_SCRIPT=./.docker.uids_gids

echo "export uid=$DEV_UID gid=$DEV_GID videogid=$VIDEO_GID kvmgid=$KVM_GID" > $UIDS_GIDS_SCRIPT

##########################
### DOCKER IMAGE BUILD ###
##########################

# Actually build the image
docker build -t mgg/android-dev ../
