#!/bin/zsh

directory=~/wallpapers
monitor=`hyprctl monitors | grep Monitor | awk '{print $2}'`

if [ -d "$directory" ]; then
    random_background=$(ls $directory/* | shuf -n 1)

    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $random_background
    hyprctl hyprpaper wallpaper "$monitor, $random_background"

    # Set system colors to current wallpaper colors
    hyprctl hyprpaper listactive | grep Virtual-1 | cut -d "=" -f2 | xargs wal -i 
fi
