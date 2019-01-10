#!/bin/bash

gcaa() {
  git add -A && git commit -m "$*"
}

updateRepo() {
  for dir in $(ls -d */); do
    cd $dir
    if [[ -d .git ]]; then
      echo "Entered directory: $dir"
      git pull
      git status
      echo
      cd ..
    else
      pullDir `pwd`
      cd ..
    fi
  done
}

updateRepo2() {
  while IFS= read -r -d $'\0' file; do
      echo "$file"
      dir=$(dirname "$file")
      base=$(basename "$file")
      echo "Updating directory ${base}"
      cd "$dir"
      git pull
      git status
  done < <(find "${HOME}" -maxdepth 2 -type d -name ".git" ! -path "${HOME}")
}

updateRepo3() {
    mapfile -t dirs < <(find "${HOME}" -maxdepth 2 -type d -name ".git" ! -path "{HOME}")

    for dir in "${dirs[@]}"; do
	dir=$(dirname "$file")
	base=$(basename "$file")
	echo "Updating directory ${base}"
	cd "$dir"
	git pull
	git status
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

