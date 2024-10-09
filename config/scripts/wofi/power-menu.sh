#!/usr/bin/env bash

# Copyright (c) 2021 Mohi Beyki <mohibeyki@gmail.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cmd="wofi -i --dmenu"

# options
shutdown=" Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend=" Suspend"
logout=" Logout"

# power options passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $cmd)"
case $chosen in
	$shutdown)
		systemctl poweroff
		;;
	$reboot)
		systemctl reboot
		;;
	$lock)
		if [[ -f /usr/bin/swaylock ]]; then
			/usr/bin/swaylock \
				--screenshots \
				--clock \
				--indicator \
				--indicator-radius 200 \
				--indicator-thickness 8 \
				--effect-blur 7x5 \
				--effect-vignette 0.5:0.5 \
				--effect-greyscale \
				--ring-color 00ffff \
				--ring-clear-color 00ffff \
				--ring-ver-color ff0000 \
				--ring-wrong-color ff0000 \
				--separator-color 00ffff \
				--text-color ffffff

		elif [[ -f /usr/bin/betterlockscreen ]]; then
			betterlockscreen -l -- --ind-pos="x+296:y+h-72"
		elif [[ -f /usr/bin/slock ]]; then
			slock
		fi
		;;
	$suspend)
		systemctl suspend
		;;
	$logout)
		if [[ "$DESKTOP_SESSION" == "hyprland" ]] || [[ "$DESKTOP_SESSION" == "hyprland-nvidia" ]]; then
			hyprctl dispatch exit
		elif [[ "$DESKTOP_SESSION" == "xmonad" ]]; then
			~/.config/scripts/xmonad/quit.sh
		elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
			i3-msg exit
		elif [[ "$DESKTOP_SESSION" == "sway" ]]; then
			swaymsg exit
		fi
		;;
esac
