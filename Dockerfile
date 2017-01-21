FROM openjdk:8

# #########################
# ## System Dependencies ##
# #########################

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    sudo \
    tmux \
    expect \
    git \
    wget

# #########################
# ###### USER UIDS #######
# #########################

COPY bin/.docker.uids_gids /tmp
RUN . /tmp/.docker.uids_gids && addgroup --gid ${kvmgid} kvm

RUN . /tmp/.docker.uids_gids && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${gid}:" >> /etc/group && \
    adduser developer kvm && \
    adduser developer video && \
    chmod 0660 /etc/sudoers && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers

# #########################
# ### Android Studio ######
# #########################

RUN curl 'https://dl.google.com/dl/android/studio/ide-zips/2.2.3.0/android-studio-ide-145.3537739-linux.zip?hl=es-419' > /tmp/studio.zip && \
    unzip /tmp/studio.zip -d /home/developer/

RUN chown -R developer:developer /home/developer/android-studio

# #########################
# ## Android dependencies ##
# #########################

COPY files/51-android.rules /etc/udev/rules.d

RUN chmod a+r /etc/udev/rules.d/51-android.rules && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    qemu-system \
    qemu-kvm \
    pciutils \
    qtbase5-dev \
    qt5-default \
    libvirt0 \
    file \
    pulseaudio \
    libncurses5-dev \
    libstdc++6 \
    va-driver-all \
    lib32z1 \
    lib32ncurses5 \
    lib32stdc++6 \
    zip \
    unzip \
    mesa-utils \
    libgl1-mesa-swx11 && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

#####################
#### ENVIRONMENT ####
#####################

RUN mkdir -p /home/developer/.bin
COPY files /home/developer/.bin
RUN chmod +x /home/developer/.bin/*.sh
RUN chown -R developer:developer /home/developer

USER developer
WORKDIR /home/developer

ENV DISPLAY=:0
ENV SHELL=/bin/bash
ENV ANDROID_HOME=/home/developer/android-sdk-linux
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

##########################
######### SDKMAN #########
##########################

RUN curl -s get.sdkman.io | bash
RUN bash -c "source /home/developer/.sdkman/bin/sdkman-init.sh"

##########################
####### ENTRYPOINT #######
##########################

ENTRYPOINT ["/home/developer/.bin/entrypoint.sh"]
