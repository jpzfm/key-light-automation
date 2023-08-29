#!/bin/bash
exec log stream --predicate 'process == "UVCAssistant" && (eventMessage CONTAINS "start stream" || eventMessage CONTAINS "Stop Stream")' |
  /usr/bin/grep -vE --line-buffered '^Filter' | # filter out the informational output at launch
  tee /dev/stderr |                             # output matching events for debugging
  /usr/bin/sed -Eu 's/.*(start|stop).*/\1/' |   # reduce the log message down to a single word identifying the event/state
  while read -r event; do                       # store that word in the $event variable
    echo "Camera $event"
    if [ "$event" = "start" ]; then
      echo "Key Light on"
      shortcuts run 'Key Light' &
    else
      echo "Key Light off"
      shortcuts run 'Key Light' &
    fi
  done