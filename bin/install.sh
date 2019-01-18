#!/bin/bash

set -euo pipefail

#apt_install='apt-get install -y -V --show-progress --no-install-recommends -o Debug::pkgProblemResolver=true -o Debug::Acquire::http=true -o Debug::pkgDPkgPM=true'
apt_install='apt-get install -y --no-install-recommends'

get_env() {
  if [[ -f /etc/os-release ]]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
    elif [[ -f /etc/lsb-release ]]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
    elif [[ -f /etc/debian_version ]]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
  fi
  
  echo "os:${OS}, ver:${VER}"
}

# Choose a user account and set home dir for install
get_user() {
  if [[ -z "${TARGET_USER}" ]]; then
    mapfile -t options < <(find /home/* -maxdepth 0 -printf "%f\\n" -type d)
    select opt in "${options[@]}"; do
      readonly TARGET_USER=$opt
      USER_DIR="/home/${TARGET_USER}"
      break
    done
  fi
  if [[ -z "${TARGET_USER}" ]]; then
    echo "Invalid user"
    exit 1
  fi
}


check_is_sudo() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
  fi
}

goto_install_dir() {
  cd "${USER_DIR}"
  if [[ ! -d "dev" ]]; then
    echo "Creating directory ${USER_DIR}/dev"
    mkdir ${USER_DIR}/dev
  fi
  cd "${USER_DIR}/dev"
}

setup_dotfiles() {
  git clone "https://github.com/mschweisthal/dotfiles.git"
  cd dotfiles
  make all
}

setup_sources() {
  cp /etc/apt/sources.list /etc/apt/sources.list.bk
}

install_packages() {
  
  apt_update
  
  install_hardware
  
  $apt_install \
  adduser \
  alpine \
  alsa-utils \
  apparmor \
  bash-completion \
  bc \
  binutils \
  bridge-utils \
  bzip2 \
  cgroupfs-mount \
  coreutils \
  dirmngr \
  file \
  findutils \
  guake \
  git \
  gnupg \
  gnupg2 \
  gnupg-agent \
  grep \
  gzip \
  indent \
  jq \
  less \
  libapparmor-dev \
  libc6-dev \
  libffi-dev \
  libltdl-dev \
  libseccomp-dev \
  libssl-dev \
  linux-generic \
  linux-headers-generic \
  linux-image-generic \
  linux-tools-generic* \
  locales \
  lsof \
  mount \
  pinentry-curses \
  rxvt-unicode-256color \
  s3cmd \
  scdaemon \
  silversearcher-ag \
  ssh \
  sudo \
  tar \
  tree \
  tzdata \
  unzip \
  xclip \
  xcompmgr \
  xz-utils \
  zip
  
  # dev
  $apt_install \
  automake \
  build-essential \
  gcc \
  make \
  python \
  python-dev \
  python-pip \
  python-paramiko \
  python-pycurl \
  python3 \
  python3-dev \
  ruby \
  ruby-dev \
  ri
  
  # chess
  $apt_install \
  xboard \
  stockfish \
  polyglot \
  fairymax \
  xfonts-100dpi \
  xfonts-75dpi
  
  # comp
  $apt_install \
  dstat \
  htop \
  iostat \
  iotop \
  strace \
  sar \
  sysstat \
  vmstat
  
  # net
  $apt_install \
  apt-transport-https \
  arptables \
  ca-certificates \
  conntrack \
  curl \
  darkstat \
  dnsutils \
  ebtables \
  hostname \
  iftop \
  ipgrab \
  iptables \
  net-tools \
  netcat \
  network-manager \
  nmap \
  openvpn \
  stunnel \
  tcpdump \
  traceroute \
  
  # window manager
  if [[ "$OS" == "Ubuntu" ]]; then
    $apt_install \
    ubuntu-mate-desktop \
    ubuntu-mate-themes \
    ubuntu-mate-wallpapers-* \
    ubuntu-mate-welcome
  fi
  
  apt_clean
}

install_hardware() {
  if [[ "$OS" == "Debian" ]]; then
    $apt_install \
    firmware-iwlwifi \
    firmware-linux-free \
    hibernate nvram-wakeup
  fi
}

install_editors() {
  $apt_install \
  emacs25 \
  emacs25-el \
  emacs25-dbg \
  vim
  
  goto_install_dir
  cd github
  
  if [[ ! -d "emacs.d" ]]; then
    echo "Downloading emacs configuration..."
    git clone https://github.com/mschweisthal/emacs.d.git .emacs.d
  fi
  python -m pip install --user virtualenv setuptools configparser
  python -m pip install --user rope jedi wheel importmagic
  python -m pip install --user autopep8 yapf flake8
}

apt_update() {
  echo "[[UPDATE]]"
  apt-get update -y
  echo "[[UPGRADE]]"
  apt-get upgrade -y
}

apt_clean() {
  echo "[[CLEAN]]"
  apt-get autoremove -y
  apt-get autoclean
  apt-get clean
  rm -rf /var/lib/apt/lists/*
}

usage() {
  echo "Usage:"
  echo "  packages  - install packages"
  echo "  dotfiles  - setup dotfiles"
  echo "  editors   - setup editors"
  echo "  update    - update apt"
}

main() {
  local cmd=$1
  
  if [[ -z "$cmd" ]]; then
    usage
    exit 1
  fi
  
  get_env
  
  if [[ $cmd == "packages" ]]; then
    check_is_sudo
    get_user
    setup_sources
    install_packages
  elif [[ $cmd == "dotfiles" ]]; then
    get_user
    setup_dotfiles
  elif [[ $cmd == "editors" ]]; then
    get_user
    install_editors
  elif [[ $cmd == "update" ]]; then
    check_is_sudo
    apt_update
    apt_clean
  else
    usage
  fi
}

main "$@"
