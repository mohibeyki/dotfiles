#!/bin/sh

nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{ printf "%d%", $1}' | awk '{ printf " %4s", $1 }'
