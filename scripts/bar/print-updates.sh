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

BAR_ICON=""
NOTIFY_ICON=/usr/share/icons/Papirus/32x32/apps/system-software-update.svg

get_total_updates() { UPDATES=$(~/.config/scripts/bar/check-updates.sh 2>/dev/null | wc -l); }

while true; do
    get_total_updates
    # notify user of updates
    if (( UPDATES > 50 )); then
        notify-send -u critical -i $NOTIFY_ICON \
            "You really need to update!" "$UPDATES New packages"
    elif (( UPDATES > 0 )); then
        notify-send -u normal -i $NOTIFY_ICON \
            "You should update soon!" "$UPDATES New packages"
   fi

    # when there are updates available
    # every 10 minutes another check for updates is done
    while (( UPDATES > 0 )); do
        if (( UPDATES >= 1 )); then
            echo "$BAR_ICON $UPDATES"
        else
            echo $BAR_ICON
        fi
        sleep 600
        get_total_updates
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every 12 hours for new updates
    while (( UPDATES == 0 )); do
        echo $BAR_ICON
        sleep 43200
        get_total_updates
    done
done
