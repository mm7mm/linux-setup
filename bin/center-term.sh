#!/bin/bash

WINDOW_CLASS="centered-term"

# البحث عن النافذة الموجودة
window_id=$(xdotool search --classname "$WINDOW_CLASS" | head -n 1)

if [ -z "$window_id" ]; then
    # إذا لم تكن النافذة موجودة، قم بإنشائها
    st -c "$WINDOW_CLASS" -g 80x25+0+0 &
    # انتظر قليلاً حتى تُنشأ النافذة
    sleep 0.5
    window_id=$(xdotool search --classname "$WINDOW_CLASS" | head -n 1)
fi

# الحصول على رقم مساحة العمل الحالية
current_workspace=$(xdotool get_desktop)

# نقل النافذة إلى مساحة العمل الحالية وتركيزها
xdotool set_desktop_for_window $window_id $current_workspace
xdotool windowactivate $window_id

# التحقق مما إذا كانت النافذة مرئية حالياً
if xwininfo -id $window_id >/dev/null 2>&1; then
    # إذا كانت مرئية، قم بإخفائها
    xdotool windowunmap $window_id
else
    # إذا كانت مخفية، قم بإظهارها
    xdotool windowmap $window_id
    xdotool windowactivate $window_id
fi
