export W="~/.steam/steam/steamapps/common/Proton 5.0/dist"
export WINEVERPATH=$W
export PATH=$W/bin:$PATH
export WINESERVER=$W/bin/wineserver
export WINELOADER=$W/bin/wine
export WINEDLLPATH=$W/lib/wine/fakedlls
export LD_LIBRARY_PATH="$W/lib:$LD_LIBRARY_PATH"
export WINEPREFIX=~/.steam/steam/steamapps/compatdata/$1/pfx
