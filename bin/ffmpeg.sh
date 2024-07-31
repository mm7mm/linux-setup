#!/bin/sh

# تحقق من وجود عملية ffmpeg التي تحتوي على خيار التسجيل
if pgrep -af 'ffmpeg.*-f' > /dev/null; then
    echo "R"
else
    echo ""
fi

# إرسال إشارة لتحديث dwmblocks
pkill -RTMIN+22 dwmblocks
