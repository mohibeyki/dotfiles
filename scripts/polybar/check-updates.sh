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

#########################################################################################
### yapuc: yet another pacman update checker, safely print a list of pending updates. ###
#########################################################################################

declare -r name='yapuc'
declare -r ver='1.0.0'

error() {
	local mesg=$1; shift
	printf "${RED}==> $(gettext "ERROR:")${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

if ! type -P fakeroot >/dev/null; then
	error 'Cannot find the fakeroot binary.'
	exit 1
fi

CHECKUPDATES_DB="${TMPDIR:-/tmp}/yapuc-db-${USER}/"
trap 'rm -f $CHECKUPDATES_DB/db.lck' INT TERM EXIT

DBPath="$(pacman-conf DBPath)"
if [[ -z "$DBPath" ]] || [[ ! -d "$DBPath" ]]; then
	DBPath="/var/lib/pacman/"
fi

mkdir -p "$CHECKUPDATES_DB"
ln -s "${DBPath}/local" "$CHECKUPDATES_DB" &> /dev/null
if ! fakeroot -- pacman -Sy --dbpath "$CHECKUPDATES_DB" --logfile /dev/null &> /dev/null; then
       error 'Cannot fetch updates'
       exit 1
fi
pacman -Qu --dbpath "$CHECKUPDATES_DB" 2> /dev/null | grep -v '\[.*\]'

exit 0

# vim: set noet:
