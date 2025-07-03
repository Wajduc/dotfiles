#!/bin/bash

# Get the window class of the currently active window
app_class=$(hyprctl activewindow -j | jq -r '.class')

# Map window class to Nerd Font icons
case "$app_class" in
Brave-browser) icon=" " ;; # Brave browser
Alacritty) icon=" " ;;
org.kde.dolphin) icon=" " ;; # File manager
discord) icon=" " ;;         # discord
vlc) icon="󰕼 " ;;             # Video player
steam) icon=" " ;;           # steam
Gimp) icon=" " ;;
*) icon=" " ;; # Fallback icon
esac

# Output JSON for Waybar
echo "{\"text\": \"$icon\"}"
