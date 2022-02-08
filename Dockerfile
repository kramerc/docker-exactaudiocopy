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
RUN xvfb-run -a winetricks -q -f dotnet20
ADD https://www.exactaudiocopy.de/eac-1.6.exe /tmp
RUN xvfb-run -a wine /tmp/eac-1.6.exe /S

# Install FLAC
RUN apt-get install -y unzip
ADD http://downloads.xiph.org/releases/flac/flac-1.3.2-win.zip /tmp
RUN unzip /tmp/flac-1.3.2-win.zip -d /tmp/ && \
    mkdir -p "/app/.wine/drive_c/Program Files/FLAC" && \
    cp /tmp/flac-1.3.2-win/win32/flac.exe "/app/.wine/drive_c/Program Files/FLAC"

COPY cdrom.reg /app
COPY eac.sh /app

USER root
RUN rm -rf /tmp/*
COPY /root /
EXPOSE 3000
VOLUME /config
