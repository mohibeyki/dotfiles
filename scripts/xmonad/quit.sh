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

# This script is used to properly quit/shutdown/etc when using XMonad
# or any other standalone window manager.

# Nicely terminates all windows, and, if everything's fine, terminate
# XMonad.

wait_for_termination() {
	# Returns 0 after the window ID $1 doesn't exists anymore (ie,
	# doesn't appear in the output of wmctrl -l). If window still
	# exists after $2 seconds, returns -1.

    end=$(($SECONDS+$2))
    
	while [ $SECONDS -lt $end ]; do
		if [[ -z `wmctrl -l | grep "^$1\s"` ]]; then
			return 0;
		fi
        sleep .05
	done
    return -1
}

for win in $(wmctrl -l | awk '{print $1}'); do
	wmctrl -ic $win;
	wait_for_termination $win 10;
    if [[ $? != 0 ]]; then
        notify-send -u critical "Cannot quit" "At least an application couldn't be closed."
        exit -1
    fi
done


# Last sanity check
if [[ -z `wmctrl -l` ]]; then
	killall xmonad-x86_64-l
else
	notify-send -u normal "Quit failed" "Relaunching termination script."
	~/.config/scripts/xmonad/quit.sh 
fi
