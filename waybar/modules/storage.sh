#!/bin/sh

mount="/"
warning=20
critical=10

df -h -P -l "$mount" | awk -v warning=$warning -v critical=$critical '
/\/.*/ {
  text=$4
  tooltip="󰋊 Filesystem: "$1"\n󰘚 Size: "$2"\n󰓢 Used: "$3"\n󰉉 Available: "$4"\n󰯂 Usage: "$5"\n󰉖 Mounted on: "$6
  use=$5
  exit 0
}
END {
  class=""
  gsub(/%$/,"",use)
  if ((100 - use) < critical) {
    class="critical"
  } else if ((100 - use) < warning) {
    class="warning"
  }
  print "{\"text\":\""text"\", \"percentage\":"use",\"tooltip\":\""tooltip"\", \"class\":\""class"\"}"
}
'
