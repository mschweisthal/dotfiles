#!/bin/bash

gcaa() {
  git add -A && git commit -m "$*"
}

pullDir() {
  for dir in $(ls -d */); do
    cd $dir
    if [[ -d .git ]]; then
      echo "Entered directory: $dir"
      git pull
      echo
      cd ..
    else
      pullDir `pwd`
      cd ..
    fi
  done
}

check_is_sudo() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root"
    exit 1
  fi
}

viewUsb() {
  for device in $(ls /sys/bus/usb/devices/*/product); do
    echo $device;
    cat $device;
  done
}
"$@"

