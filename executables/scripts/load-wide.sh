xrandr | grep "2560x1080  59" | rev | cut -c 10- | rev | xargs -I{} sh ~/.scripts/load-wide-layout.sh {}

