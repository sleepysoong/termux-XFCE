#!/data/data/com.termux/files/usr/bin/bash

echo "현재 배경화면 설정에 오류가 있어 임시 배경화면을 선택해야합니다."
# Directory containing the wallpapers
WALLPAPER_DIR="/data/data/com.termux/files/usr/share/backgrounds/xfce"
TARGET_WALLPAPER="$WALLPAPER_DIR/xfce-x.svg"
BACKUP_WALLPAPER="$WALLPAPER_DIR/xfce-x_bak.svg"
# Check if xfce-x.svg exists and back it up
if [ -f "$TARGET_WALLPAPER" ]; then
    echo "Backing up existing xfce-x.svg to xfce-x.bak"
    mv -f "$TARGET_WALLPAPER" "$BACKUP_WALLPAPER"
fi

# List all images in the directory
echo "Available wallpapers:"
select wallpaper in "$WALLPAPER_DIR"/*; do
    if [ -n "$wallpaper" ]; then
        echo "You selected: $wallpaper"
        
        # Copy the selected wallpaper and rename it to xfce-x.svg
        cp "$wallpaper" "$TARGET_WALLPAPER"
        echo "Copied and renamed to xfce-x.svg."
        # Set the new wallpaper in XFCE
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image --create -t string -s "$TARGET_WALLPAPER"

        echo "Wallpaper updated successfully! Please restart."
        exit 0
    else
        echo "Invalid selection. Please try again."
    fi
done