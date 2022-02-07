#!/bin/bash

# Persist user registry (EAC stores settings here)
if [ ! -f /config/user.reg ];
then
    cp /app/.wine/user.reg /config/user.reg
fi
rm /app/.wine/user.reg
ln -s /config/user.reg /app/.wine/user.reg

# Persist appdata
mkdir -p /config/AccurateRip /config/EAC
mkdir -p "/app/.wine/drive_c/users/abc/Application Data"
ln -s /config/AccurateRip "/app/.wine/drive_c/users/abc/Application Data/AccurateRip"
ln -s /config/EAC "/app/.wine/drive_c/users/abc/Application Data/EAC"

export WINEPREFIX=/app/.wine
/usr/bin/wine reg import /app/cdrom.reg
/usr/bin/wine "/app/.wine/drive_c/Program Files/Exact Audio Copy/EAC.exe"
