FROM --platform=linux/amd64 ghcr.io/linuxserver/baseimage-rdesktop-web:focal

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y xvfb wine wine32 wine64 libwine libwine:i386 fonts-wine

# Install Winetricks
RUN curl -o /tmp/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /tmp/winetricks && \
    mv -v /tmp/winetricks /usr/local/bin

# Configure Wine
ENV WINEPREFIX=/app/.wine WINEARCH=win32
RUN apt-get install -y cabextract
RUN xvfb-run -a winetricks -q -f dotnet20 dotnet40 vcrun2015

# Install EAC
ARG EAC_VERSION=1.6
ADD https://www.exactaudiocopy.de/eac-${EAC_VERSION}.exe /tmp
RUN xvfb-run -a wine /tmp/eac-${EAC_VERSION}.exe /S

# Need unzip
RUN apt-get install -y unzip

# Install FLAC
ARG FLAC_VERSION=1.3.4
ADD http://downloads.xiph.org/releases/flac/flac-${FLAC_VERSION}-win.zip /tmp
RUN unzip /tmp/flac-${FLAC_VERSION}-win.zip -d /tmp/ && \
    mkdir -p "/app/.wine/drive_c/Program Files/FLAC" && \
    cp /tmp/flac-${FLAC_VERSION}-win/win32/flac.exe "/app/.wine/drive_c/Program Files/FLAC"

# Update CTDB EAC plugin
ARG CUE_VERSION=2.2.2
ADD https://github.com/gchudov/cuetools.net/releases/download/v${CUE_VERSION}/CUETools_${CUE_VERSION}.zip /tmp
RUN unzip /tmp/CUETools_${CUE_VERSION}.zip -d /tmp/ && \
    cp /tmp/CUETools_${CUE_VERSION}/interop/EAC/* "/app/.wine/drive_c/Program Files/Exact Audio Copy"

COPY cdrom.reg /app
COPY eac.sh /app

USER root
RUN rm -rf /tmp/*
COPY /root /
EXPOSE 3000
VOLUME /config
