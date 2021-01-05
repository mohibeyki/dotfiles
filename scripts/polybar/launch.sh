#!/usr/bin/env bash

pgrep -u $UID -x polybar >/dev/null && echo "Polybar is already running" || polybar -c ~/.config/polybar/config.ini -r ${1-ewmh} &
