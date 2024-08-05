#!/bin/bash

WINDOW_NAME="centered-term"
GEOMETRY="80x25+0+0"

# البحث عن النافذة
window_id=$(wmctrl -l | grep "$WINDOW_NAME" | awk '{print $1}')

if [ -z "$window_id" ]; then
    # إذا لم تكن النافذة موجودة، قم بإنشائها
    st -c "$WINDOW_NAME" -g "$GEOMETRY" &
    sleep 0.5
    window_id=$(wmctrl -l | grep "$WINDOW_NAME" | awk '{print $1}')
else
    # إذا كانت النافذة موجودة، تحقق من حالتها
    if wmctrl -l | grep "$WINDOW_NAME" | grep -q " $(xdotool get_desktop) "; then
        # النافذة مرئية، قم بإخفائها
        wmctrl -ir "$window_id" -b add,hidden
    else
        # النافذة مخفية، قم بإظهارها
        wmctrl -ir "$window_id" -b remove,hidden
        wmctrl -ia "$window_id"
    fi
fi
