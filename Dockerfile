FROM dorowu/ubuntu-desktop-lxde-vnc:focal

RUN \
  echo "**** Install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    dbus \
    fcitx-rime \
    fonts-wqy-microhei \
    jq \
    libnss3 \
    libqpdf26 \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    python3 \
    python3-xdg \
    ttf-wqy-zenhei \
    wget \
    xz-utils \
    wine64 && \
  echo "**** Install calibre ****" && \
  mkdir -p \
    /opt/calibre && \
  if [ -z ${CALIBRE_RELEASE+x} ]; then \
    CALIBRE_RELEASE=$(curl -sX GET "https://api.github.com/repos/kovidgoyal/calibre/releases/latest" \
    | jq -r .tag_name); \
  fi && \
  CALIBRE_VERSION="$(echo ${CALIBRE_RELEASE} | cut -c2-)" && \
  CALIBRE_URL="https://download.calibre-ebook.com/${CALIBRE_VERSION}/calibre-${CALIBRE_VERSION}-x86_64.txz" && \
  curl -o \
    /tmp/calibre-tarball.txz -L \
    "$CALIBRE_URL" && \
  tar xvf /tmp/calibre-tarball.txz -C \
    /opt/calibre && \
  /opt/calibre/calibre_postinstall && \
  dbus-uuidgen > /etc/machine-id && \
  echo "**** Setup wine and install Adobe ****" && \
  mkdir -p ~/.wine && \
  mkdir -p ~/Adobe_Digital_Edition && \
  curl -o ~/Adobe_Digital_Edition/ADE_4_5_Installer.exe https://adedownload.adobe.com/pub/adobe/digitaleditions/ADE_4.5_Installer.exe && \
  echo "**** Cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
    
# add local files
COPY root/ /
