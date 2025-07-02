#!/bin/bash

# --- Configuration ---
LANDSCAPE_DIR="/home/notme/trap/pictures/wallpapers/lock/landscape"
PORTRAIT_DIR="/home/notme/trap/pictures/wallpapers/lock/portrait"

# --- Temp File ---
COMPOSITE_IMG="/tmp/lock_composite.png"

# --- Create Composite Image ---
XRANDR_INFO=$(xrandr --query | grep " connected")
MONITOR_ONE_LINE=$(echo "$XRANDR_INFO" | head -n 1)
MONITOR_TWO_LINE=$(echo "$XRANDR_INFO" | tail -n 1)
RES_ONE=$(echo "$MONITOR_ONE_LINE" | grep -oP '\d+x\d+')
POS_ONE=$(echo "$MONITOR_ONE_LINE" | grep -oP '\d+x\d+\+\K\d+\+\d+')
X_ONE=$(echo "$POS_ONE" | cut -d'+' -f1)
WIDTH_ONE=$(echo "$RES_ONE" | cut -d'x' -f1)
HEIGHT_ONE=$(echo "$RES_ONE" | cut -d'x' -f2)
RES_TWO=$(echo "$MONITOR_TWO_LINE" | grep -oP '\d+x\d+')
POS_TWO=$(echo "$MONITOR_TWO_LINE" | grep -oP '\d+x\d+\+\K\d+\+\d+')
X_TWO=$(echo "$POS_TWO" | cut -d'+' -f1)
WIDTH_TWO=$(echo "$RES_TWO" | cut -d'x' -f1)
HEIGHT_TWO=$(echo "$RES_TWO" | cut -d'x' -f2)
RANDOM_LANDSCAPE_IMG=$(find "$LANDSCAPE_DIR" -type f -name "*.*" | shuf -n 1)
RANDOM_PORTRAIT_IMG=$(find "$PORTRAIT_DIR" -type f -name "*.*" | shuf -n 1)
if [ "$X_ONE" -lt "$X_TWO" ]; then
    LEFT_RES=$RES_ONE; LEFT_WIDTH=$WIDTH_ONE; LEFT_HEIGHT=$HEIGHT_ONE; RIGHT_RES=$RES_TWO
else
    LEFT_RES=$RES_TWO; LEFT_WIDTH=$WIDTH_TWO; LEFT_HEIGHT=$HEIGHT_TWO; RIGHT_RES=$RES_ONE
fi
if [ "$LEFT_WIDTH" -gt "$LEFT_HEIGHT" ]; then
    LEFT_IMG=$RANDOM_LANDSCAPE_IMG; RIGHT_IMG=$RANDOM_PORTRAIT_IMG
else
    LEFT_IMG=$RANDOM_PORTRAIT_IMG; RIGHT_IMG=$RANDOM_LANDSCAPE_IMG
fi

# Create the composite image in the correct LEFT-TO-RIGHT order
magick \( "$LEFT_IMG" -resize "${LEFT_RES}^" -gravity center -extent "$LEFT_RES" \) \
       \( "$RIGHT_IMG" -resize "${RIGHT_RES}^" -gravity center -extent "$RIGHT_RES" \) \
       -gravity North +append "$COMPOSITE_IMG"


# --- Lock the Screen ---
i3lock -i "$COMPOSITE_IMG" -t

# --- Clean up ---
rm "$COMPOSITE_IMG"