#!/bin/bash

# تعيين اسم واجهة الشبكة
INTERFACE="wlp2s0"

# إيقاف واجهة الشبكة
echo "Bringing down the Wi-Fi interface $INTERFACE..."
doas ip link set "$INTERFACE" down

# تحقق من حالة واجهة الشبكة
if ip link show "$INTERFACE" | grep -q "state DOWN"; then
    echo "$INTERFACE is now down."
else
    echo "Failed to bring $INTERFACE down."
fi

