#!/usr/bin/env bash

# #########################
# ### Android EMULATOR ####
# #########################

source android-env.sh && \
which adb && \
which android && \
echo "no" | android create avd \
                    --force \
                    --device "Nexus 5" \
                    --name test \
                    --target android-24 \
                    --abi armeabi-v7a \
                    --skin WVGA800 \
                    --sdcard 512M
