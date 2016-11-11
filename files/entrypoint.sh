#!/usr/bin/env bash

# #########################
# ## Android Entrypoint ###
# #########################

tmux -2 new-session -d -s android

tmux rename-window -t android:0 'android-tools'
tmux select-window -t android:0
tmux send-keys -t android 'source /home/dev/.bin/android-env.sh' C-m

tmux rename-window -t android:1 'intellij'
tmux select-window -t android:1
tmux send-keys -t android 'ls' C-m

tmux -2 attach-session -t android
