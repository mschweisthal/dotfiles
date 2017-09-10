#!/bin/bash

set -e

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

    echo "OS:${OS}, VERSION:${VER}"
}

# Choose a user account to use for this installation
get_user() {
    if [ -z "${TARGET_USER-}" ]; then
       PS3='Which user account should be used? '
       options=$(find /home/* -maxdepth 0 -printf "%f\n" -type d)
       select opt in "${options[@]}"; do
           readonly TARGET_USER=$opt
           break
       done
    fi
}

check_is_sudo() {
    if [ "$EUID" -ne 0 ]; then
	echo "Please run as root."
	exit
    fi
}

goto_install_dir() {
    cd "${HOME}" 
    if [[ ! -d "dev" ]]; then
	echo "Creating directory ${HOME}/dev"
   	mkdir ${HOME}/dev
    fi
    cd "${HOME}/dev"
}

setup_dotfiles() {
    #git clone "https://github.com/mschweisthal/dotfiles.git"
    ln -snf "${HOME}/dev/dotfiles/vimrc" "${HOME}/.vimrc"
    ln -snf "${HOME}/dev/dotfiles/emacs.d" "${HOME}/.emacs.d"
}

setup_sources() {
    cp /etc/apt/sources.list /etc/apt/sources.list.bk
}

install_packages() {
    apt-get update
    apt-get upgrade -y
    apt-get install -y \
# base
        adduser \
        alpine \
        alsa-utils \
        apparmor \
        automake \
        bash-completion \
        bc \
        bridge-utils \
        bzip2 \
        cgroupfs-mount \
        coreutils \
        curl \
        dirmngr \
        file \
        findutils \
        guake \
        gcc \
        git \
        gnupg \
        gnupg2 \
        gnupg-agent \
	#google-cloud-sdk \
        grep \
	gzip \
	htop \
	jq \
	less \
	libapparmor-dev \
	libc6-dev \
	libltdl-dev \
	libseccomp-dev \
	linux-generic \
	linux-headers-generic \
	linux-image-generic \
	linux-tools-generic* \
	locales \
	lsof \
	make \
	mount \
	pinentry-curses \
	rxvt-unicode-256color \
	s3cmd \
	scdaemon \
	silversearcher-ag \
	ssh \
	strace \
	sudo \
	tar \
	tree \
	tzdata \
	unzip \
	xclip \
	xcompmgr \
	xz-utils \
	zip \
# editors
	emacs25 \
	emacs25-el \
	emacs25-dbg \
	vim \
# net
    	apt-transport-https \
    	ca-certificates \
	conntrack \
    	curl \
	darkstat \
    	dnsutils \
	hostname \
	indent \
	ipgrab \
	iptables \
	mail-utils \
	nc \
	net-tools \
	network-manager \
	nmap \
	ntop \
	openvpn \
	tcpdump \
	tripwire \
    --no-install-recommends

    install_extra_net

# window manager
    if [[ "$OS"  == "Ubuntu" ]]; then
	apt-get install -y \
	    ubuntu-mate-desktop \
	    ubuntu-mate-themes \
	    ubuntu-mate-wallpapers-* \
	    ubuntu-mate-welcome
	--no-install-recommends
    fi

    apt-get autoremove
    apt-get autoclean
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}

install_extra_net() {
    goto_install_dir
    cd github
    git clone https://github.com/LionSec/katoolin.git
    if [[ -d "katoolin" ]]; then
	echo "Katoolin created..."
	cd katoolin
	python katoolin.py
    else
	echo "Katoolin not created. Exiting..."
	exit 1
    fi
}

install_scripts() {
    echo
}

update_apt() {
    apt-get update -y
    apt-get upgrade -y
    apt-get autoremove -y
    apt-get autoclean
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}

usage() {
    echo "Usage:"
    echo "  packages  - setup sources & install packages"
    echo "  dotfiles  - setup dotfiles"
    echo "  scripts   - install scripts"
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
    elif [[ $cmd == "scripts" ]]; then
	get_user
    	install_scripts
    elif [[ $cmd == "update" ]]; then
	check_is_sudo
	update_apt
    else
    	usage
    fi
}

main "$@"

