#!/bin/bash

# تعيين الأجهزة يدويًا إذا كانت معروفة
stylus=$(xsetwacom --list | grep -i stylus | awk '{print $8}')
eraser=$(xsetwacom --list | grep -i eraser | awk '{print $8}')
touch=$(xsetwacom --list | grep -i touch | awk '{print $8}')

# تحقق من وجود الأجهزة
if [ -z "$stylus" ]; then
    echo "Cannot find stylus device."
else
    xsetwacom --set $stylus rotate half
fi

if [ -z "$eraser" ]; then
    echo "Cannot find eraser device."
else
    xsetwacom --set $eraser rotate half
fi

if [ -z "$touch" ]; then
    echo "Cannot find touch device."
else
    xsetwacom --set $touch touch off
fi

# إعدادات التسجيل
tmpPID="/tmp/screencast.pid"
outputDir="$HOME/screencast"
timestamp=$(date '+%Y%m%d_%H%M%S')
outputFile="$outputDir/$timestamp.mov"

# التحقق من المايكروفون
mic=$(arecord -l | awk '/USB/ {sub(":",""); print $2}')

if [ -z "$mic" ]; then
    echo "No USB microphone found."
    exit 1
fi

if [ -s $tmpPID ]; then
    kill $(cat $tmpPID)
    rm -rf $tmpPID
else
    mkdir -p "$outputDir"
    ffmpeg -framerate 24 -video_size 1366x768 -f x11grab -i :0.0 -f alsa -i hw:$mic -vcodec h264_nvenc -preset fast -threads 0 -acodec pcm_s32le -ac 1 -ab 320k "$outputFile" & echo $! > $tmpPID
fi

# تحديث dwmblocks
pkill -RTMIN+10 dwmblocks
