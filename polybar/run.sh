#!/usr/bin/env sh
killall -q polybar
polybar -r top && polybar -r bottom
