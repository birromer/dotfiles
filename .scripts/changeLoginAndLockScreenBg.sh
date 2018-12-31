    #!/bin/bash
    #
    # ===================================================
    # Change background for login and lock screens.
    #
    # 2.3.16
    # Borysn
    #
    # args
    # $1 : theme name
    # $2 : path to new wallpaper
    #
    # usage:
    # $ changeLoginAndLockScreenBg <theme name> <path/to/new/wallaper>
    # i.e.
    # $ changeLoginAndLockScreenBg breeze ./arch-linux-black.png
    # ===================================================

    # =====================
    # initial checks
    # =====================

    # check root
    if [ "$(id -u)" != "0" ]; then
    	echo "You do not have the appropriate privileges..."
    	exit 1
    fi

    # =====================
    # script
    # =====================

    # script start
    echo "Setting new lock/login screen wallpaper..."

    # =====================
    # theme directories
    # =====================

    # login background
    sddmDir=/usr/share/sddm/themes/"$1"/
    # lock screen background
    plasmaDir=/usr/share/plasma/look-and-feel/org.kde."$1".desktop/contents/
    # background dir
    artworkDir=components/artwork/

    # =====================
    # var checks
    # =====================

    # check if user supplied theme name
    if [ -z "$1" ]; then
    	echo "You did not supply a theme name."
    	exit 1
    fi

    # check if directories exist
    if [ ! -d "$sddmDir" ] || [ ! -d "$plasmaDir" ]; then
    	echo "You've supplied an invalid theme name."
    	exit 1
    fi

    # check if user supplied new wallpaper path
    if [ -z "$2" ]
    then
    	echo "You did not supply the new wallpaper path."
    	exit 1
    fi

    # check if wallpaper exists
    if [ ! -e "$2" ]; then
    	echo "You supplied an invalid path for the new wallpaper."
    	exit 1
    fi

    # =====================
    # print user args
    # =====================

    echo ""
    echo "[theme name]"
    echo "    $1"
    echo "[new wallpaper]"
    echo "    $2"
    echo ""
    echo "[sddm theme dir (login)]"
    echo "    $sddmDir"
    echo "[plasma theme dir (lock)]"
    echo "    $plasmaDir"
    echo ""

    # =====================
    # backup current background
    # =====================

    sddmBgPath="$sddmDir""$artworkDir"
    plasmaBgPath="$plasmaDir""$artworkDir"

    # check if current sddm theme backup already exists
    if [ ! -e "$sddmBgPath""background.png.save" ]; then
    	# if it does not exist, back it up
    	echo "[back up current sddm background]"
    	echo "    $sddmBgPath""background.png => background.save.png"
    	mv "$sddmBgPath""background.png" "$sddmBgPath""background.png.save"
    fi

    # check if current plasma theme backup already exists
    if [ ! -e "$plasmaBgPath""background.png.save" ]; then
    	# if it does not exist, back it up
    	echo "[back up current plasma background]"
    	echo "    $plasmaBgPath""background.png => background.save.png"
    	mv "$plasmaBgPath""background.png" "$plasmaBgPath""background.png.save"
    fi

    echo ""

    # =====================
    # copy new background
    # =====================

    # copy new sddm background
    echo "[copying new background to sddm and plasma]"
    echo "    $2 => $sddmBgPath""background.png"
    echo "    $2 => $plasmaBgPath""background.png"
    cp "$2" "$sddmBgPath""background.png"
    cp "$2" "$plasmaBgPath""background.png"

    exit 0
