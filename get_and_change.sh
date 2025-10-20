#!/bin/bash
#
# Original by: KZKG^Gaara (https://x.com/kzkggaara)

if pgrep -x "plasmashell" >/dev/null; then

    WALLPAPER=$(find /data/Wallpapers -type f | shuf -n 1)

    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
    var Desktops = desktops();                                                                                                                       
    for (i=0;i<Desktops.length;i++) {
        d = Desktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper",
            "org.kde.image",
            "General");
        d.writeConfig("Image", "file://'$WALLPAPER'");
    }'
    kwriteconfig5 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$WALLPAPER"

else
    echo ""
    echo "Sorry dude but you are not using KDE Plasma"
    echo "This script is only for KDE Plasma's users"
    echo ""
fi
