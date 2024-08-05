#!/bin/sh
(sleep 2; physlock -d) &  # سيقوم بتشغيل physlock بعد ثانيتين
doas zzz
