FROM mgg/jvm

USER root

# #########################
# ## System Dependencies ##
# #########################

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --force-yes \
    expect \
    git \
    wget \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    python \
    curl \
    pciutils \
    mesa-utils \
    libqt5widgets5 && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# #########################
# ###### Build Tools ######
# #########################

ENV PATH ${PATH}:${HOME_BIN}
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

COPY files ${HOME_BIN}
RUN chmod +x ${HOME_BIN}/*.sh
RUN chown -R dev:dev ${HOME_BIN}/*.sh

# #########################
# ##### USB Debugging #####
# #########################

COPY files/51-android.rules /etc/udev/rules.d
RUN chmod a+r /etc/udev/rules.d/51-android.rules
RUN usermod -aG video dev

USER dev

# #########################
# ### Android Studio ######
# #########################

RUN curl 'https://dl.google.com/dl/android/studio/ide-zips/2.2.3.0/android-studio-ide-145.3537739-linux.zip?hl=es-419' > /tmp/studio.zip && \
    unzip /tmp/studio.zip -d /home/dev/

# #########################
# ###### Android SDK ######
# #########################

# The following commands MUST be executed in ONE RUN
# execution. Explanation at:
# http://stackoverflow.com/questions/30301198/android-sdk-tools-install-in-docker-fails
RUN cd && \
    wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar xzf android-sdk.tgz && \
    rm -f android-sdk.tgz && \
    chown -R dev.dev android-sdk-linux && \
    android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools" && \
    android-accept-licenses.sh "android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,build-tools-21.0.0,build-tools-21.0.1,build-tools-21.0.2,build-tools-21.1.0,build-tools-21.1.1,build-tools-21.1.2,build-tools-22.0.0,build-tools-22.0.1,build-tools-23.0.0,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3,build-tools-25.0.0,android-21,android-22,android-23,android-24,android-25,addon-google_apis_x86-google-21,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,sys-img-armeabi-v7a-android-24"

# #########################
# # Checking Installation #
# #########################

RUN ${HOME_BIN}/android-test.sh

ENTRYPOINT ["/home/dev/.bin/entrypoint.sh"]
