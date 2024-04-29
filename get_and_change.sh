#!/bin/bash
#
# Author: KZKG^Gaara (https://x.com/kzkggaara)
#
# Requerimientos:
# - KDE Plasma
# - wget
# - curl
# 
# Que hace?:
# 1. Comprueba si usas KDE [linea 18]
# 2. Obtiene un numero aleatorio [linea 20]
# 3. Estableces tu resolucion de pantalla [linea 21]
# 3. Descarga un wallpaper aleatorio en /tmp/ [linea 23]
# 4. Establece ese wallpaper como default en todos tus escritorios [linea 25-34]
# 5. Elimina el anterior wallpaper descargado la vez pasada [linea 36]

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
    echo "No estás utilizando KDE Plasma"
    echo "Este script está programado pensando en usarse solo en KDE"
    echo ""
fi
