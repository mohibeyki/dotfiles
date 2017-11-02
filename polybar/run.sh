#!/usr/bin/env sh
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar traybar &
polybar topbar1 &
polybar topbar2 &

