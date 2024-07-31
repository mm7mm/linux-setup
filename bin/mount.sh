#!/bin/bash

# Define mount directory
MOUNT_DIR="/mnt"

# Ensure the main mount directory exists
if [ ! -d "$MOUNT_DIR" ]; then
    mkdir -p "$MOUNT_DIR"
fi

# Function to mount a device
mount_device() {
    DEVICE="$1"
    LABEL="$2"
    MOUNT_POINT="$MOUNT_DIR/$LABEL"

    # Ensure the mount point directory exists
    if [ ! -d "$MOUNT_POINT" ]; then
        mkdir -p "$MOUNT_POINT"
    fi

    # Mount the device using doas
    doas mount "/dev/$DEVICE" "$MOUNT_POINT"
    echo "Mounted device /dev/$DEVICE at $MOUNT_POINT"
}

# Function to unmount a device
unmount_device() {
    DEVICE="$1"
    LABEL="$2"
    MOUNT_POINT="$MOUNT_DIR/$LABEL"

    # Unmount the device using doas
    doas umount "$MOUNT_POINT"
    echo "Unmounted device /dev/$DEVICE from $MOUNT_POINT"

    # Remove the mount point directory
    doas rm -rf "$MOUNT_POINT"
}

# Get list of all partitions and display in a vertical menu
DEVICE=$(lsblk -ln -o NAME,SIZE,TYPE,LABEL,MOUNTPOINT | grep 'part' | awk '{printf "%s (%s) %s\n", $1, $2, $4}' | dmenu -i -l 10 -p "Select partition:")

# Ensure the user selected a partition
if [ -z "$DEVICE" ]; then
    echo "No device selected."
    exit 1
fi

# Extract the actual device name and label from the selected entry
DEVICE_NAME=$(echo "$DEVICE" | awk '{print $1}')
DEVICE_LABEL=$(echo "$DEVICE" | awk '{print $3}')
if [ -z "$DEVICE_LABEL" ]; then
    DEVICE_LABEL="$DEVICE_NAME"
fi

# Check if the device is already mounted
MOUNTED=$(lsblk -ln -o MOUNTPOINT "/dev/$DEVICE_NAME" | grep -v '^$')
if [ -n "$MOUNTED" ]; then
    # Device is already mounted, ask user to unmount
    RESPONSE=$(echo -e "Unmount\nCancel" | dmenu -i -p "Device /dev/$DEVICE_NAME is already mounted. What do you want to do?")
    case "$RESPONSE" in
        "Unmount")
            unmount_device "$DEVICE_NAME" "$DEVICE_LABEL"
            ;;
        "Cancel")
            echo "Operation canceled."
            exit 0
            ;;
    esac
else
    # Device is not mounted, ask user to mount
    RESPONSE=$(echo -e "Mount\nCancel" | dmenu -i -p "Device /dev/$DEVICE_NAME is not mounted. What do you want to do?")
    case "$RESPONSE" in
        "Mount")
            mount_device "$DEVICE_NAME" "$DEVICE_LABEL"
            ;;
        "Cancel")
            echo "Operation canceled."
            exit 0
            ;;
    esac
fi

exit 0
