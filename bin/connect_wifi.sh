#!/bin/bash

# تعيين اسم واجهة الشبكة
INTERFACE="wlp2s0"
#!/bin/bash

# تعيين اسم واجهة الشبكة
INTERFACE="wlp2s0"
CONFIG_FILE="/etc/wpa_supplicant/wpa_supplicant.conf"

# إلغاء قفل واجهة Wi-Fi إذا كانت محجوزة
echo "Unblocking Wi-Fi..."
doas rfkill unblock wifi

# إيقاف أي عملية wpa_supplicant قيد التشغيل
echo "Stopping any existing wpa_supplicant processes..."
doas killall wpa_supplicant

# حذف ملفات واجهة التحكم المتبقية إذا كانت موجودة
CONTROL_FILE="/run/wpa_supplicant/$INTERFACE"
if [ -e "$CONTROL_FILE" ]; then
    echo "Deleting existing control interface file..."
    doas rm "$CONTROL_FILE"
fi

# تشغيل wpa_supplicant مع التكوين المحدد
echo "Starting wpa_supplicant..."
doas wpa_supplicant -B -i "$INTERFACE" -c "$CONFIG_FILE"

# تحقق من حالة التشغيل
if [ $? -eq 0 ]; then
    echo "wpa_supplicant started successfully."
else
    echo "Failed to start wpa_supplicant."
fi

