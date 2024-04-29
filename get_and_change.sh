#!/bin/bash
#
# Author: KZKG^Gaara (https://x.com/kzkggaara)
#
# Requirements:
# - KDE Plasma
# - wget
# - curl
# 
# What does this script do?:
# 1. Check if you are using KDE [line 18]
# 2. Get a random number [line 20]
# 3. Set your screen resolution [line 21]
# 3. Download to /tmp/ some random wallpaper [line 23]
# 4. Put the wallpaper as default in all your desktops [line 25-34]
# 5. Delete the old one downloaded last time [line 36]

if pgrep -x "plasmashell" >/dev/null; then

    RANDOM_NUMBER=$RANDOM
    SCREEN_RESOLUTION="1920x1080" 

    wget $(curl -s --location --request GET 'https://wallhaven.cc/api/v1/search' --header 'Content-Type: application/json' --data-raw '{"sorting": "random","resolutions": "'$SCREEN_RESOLUTION'"}' | jq .data | grep "path" | head -n 1 | awk {'print $2'} | sed 's|"||g' | sed 's|,||g') -O /tmp/random_wallpaper_$RANDOM_NUMBER -o /dev/null

    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
    var Desktops = desktops();                                                                                                                       
    for (i=0;i<Desktops.length;i++) {
        d = Desktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper",
            "org.kde.image",
            "General");
        d.writeConfig("Image", "file:///tmp/random_wallpaper_'$RANDOM_NUMBER'");
    }'

    ls -d /tmp/random_wallpaper* | grep -v $RANDOM_NUMBER | xargs rm

else
    echo ""
    echo "Sorry dude but you are not using KDE Plasma"
    echo "This script is only for KDE Plasma's users"
    echo ""
fi
