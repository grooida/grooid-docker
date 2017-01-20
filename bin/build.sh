#!/bin/bash
cd `dirname $0`

# Select uid/gid of developer, kvm and video
DEV=`whoami`
DEV_UID=`egrep ^$DEV /etc/passwd|cut -d':' -f3`
DEV_GID=`egrep ^$DEV /etc/passwd|cut -d':' -f4`
KVM_GID=`egrep ^kvm /etc/group|cut -d':' -f3`
VIDEO_GID=`egrep ^video /etc/group|cut -d':' -f3`
if [ "x$KVM_GID" == "x" ] ; then
  echo "You do not have kvm group in your system, install qemu-kvm or equivalent"
  echo "Cancelled"
  exit 1
fi
if [ "x$VIDEO_GID" == "x" ] ; then
  echo "You do not have video group in your system, you will not be able to run emulator in Android Studio"
  echo "Cancelled"
  exit 1
fi

echo "In your host system, the gids of the video,kvm groups are respectively $VIDEO_GID,$KVM_GID"
echo "Your username is `whoami` with uid=$DEV_UID and gid=$DEV_GID"
echo "Do you want to change uid,gid? [YES/no]"
read YESNO
if [ "x$YESNO" == "xYES" ] ; then
  echo "Enter desired developer uid: "
  read DEV_UID
  echo "Enter desired developer gid: "
  read DEV_GID
fi
UIDS_GIDS_SCRIPT=./.docker.uids_gids
echo "export uid=$DEV_UID gid=$DEV_GID videogid=$VIDEO_GID kvmgid=$KVM_GID" > $UIDS_GIDS_SCRIPT

# Actually build the image
docker build -t mgg/android-dev ../
