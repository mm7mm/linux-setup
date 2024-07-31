#!/bin/bash

# Terminate any existing wpa_supplicant process
doas pkill wpa_supplicant
echo "Terminated any existing wpa_supplicant process."

# Disable Wi-Fi interface
doas ip link set wlp2s0 down
echo "Disabled Wi-Fi interface."

# Block Wi-Fi
doas rfkill block wifi
echo "Blocked Wi-Fi."

