#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Terminate any existing wpa_supplicant process
doas pkill wpa_supplicant
echo "Terminated any existing wpa_supplicant process."

# Unblock Wi-Fi
doas rfkill unblock wifi
echo "Unblocked Wi-Fi."

# Remove any existing wpa_supplicant control interface file
doas rm -f /run/wpa_supplicant/wlp2s0
echo "Removed any existing wpa_supplicant control interface file."

# Enable Wi-Fi interface
doas ip link set wlp2s0 up
echo "Enabled Wi-Fi interface."

# Wait a few seconds to ensure the interface is up
sleep 5

# Configure the Wi-Fi connection using wpa_supplicant
doas wpa_supplicant -B -i wlp2s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
if [ $? -eq 0 ]; then
  echo "Configured Wi-Fi connection using wpa_supplicant."
else
  echo "Failed to configure Wi-Fi connection using wpa_supplicant."
  exit 1
fi

# Wait a few seconds for wpa_supplicant to establish connection
sleep 5

# Obtain an IP address using dhcpcd
doas dhcpcd wlp2s0
if [ $? -eq 0 ]; then
  echo "Obtained an IP address using dhcpcd."
else
  echo "Failed to obtain an IP address using dhcpcd."
  exit 1
fi

echo "Successfully connected to Wi-Fi."

