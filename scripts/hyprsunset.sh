#!/usr/bin/env bash

# Kill current hyprsunset session
killall -q hyprsunset

# Get the current hour (in 24-hour format)
current_hour=$(date +%H)

# If it’s 6pm to 7am, hyprsunset -t 5000
if [ "$current_hour" -ge 22 ] || [ "$current_hour" -le 6 ]; then
  echo "Changing to nighttime hyprsunset"
  hyprsunset -t 5500
fi
