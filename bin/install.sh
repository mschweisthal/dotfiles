#!/bin/bash

set -e

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

# Choose a user account to use for this installation
get_user() {
    if [[ -z "${TARGET_USER}" ]]; then
       PS3='Which user account should be used? '
       options=$(find /home/* -maxdepth 0 -printf "%f\n" -type d)
       select opt in "${options[@]}"; do
           readonly TARGET_USER=$opt
	   if [[ -z "${TARGET_USER}" ]]; then
	       echo "Invalid user"
	       exit 1
	   fi
	   USER_DIR="/home/${TARGET_USER}"
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
    cd "${USER_DIR}" 
    if [[ ! -d "dev" ]]; then
	echo "Creating directory ${USER_DIR}/dev"
   	mkdir ${USER_DIR}/dev
    fi
    cd "${USER_DIR}/dev"
}

setup_dotfiles() {
    #git clone "https://github.com/mschweisthal/dotfiles.git"
    ln -snf "${USER_DIR}/dev/dotfiles/vimrc" "${USER_DIR}/.vimrc"
    ln -snf "${USER_DIR}/dev/dotfiles/emacs.d" "${USER_DIR}/.emacs.d"
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
# editors
    $apt_install \
	emacs25 \
	emacs25-el \
	emacs25-dbg \
	vim
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
	strace \
	sysstat
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
	tripwire

    install_extra_net

# window manager
    if [[ "$OS" == "Ubuntu" ]]; then
	$apt_install \
	    ubuntu-mate-desktop \
	    ubuntu-mate-themes \
	    ubuntu-mate-wallpapers-* \
	    ubuntu-mate-welcome
    fi

    apt_clean
    
# python stuff
#    pip install easy_install
#    pip install markupsafe
#    pip install dopy==0.3.5
#    pip install setuptools --upgrade
#    pip install setuptools_ext
#    pip install six --upgrade
#    pip install cffi --upgrade
#    pip install cryptography --upgrade
#    pip install ansible
}

install_hardware() {
    if [[ "$OS" == "Debian" ]]; then
	$apt_install \
            firmware-iwlwifi \
	    firmware-linux-free \ 
	    hibernate nvram-wakeup \ 
    fi
}

install_extra_net() {
    goto_install_dir
    cd github
    if [[ -d "katoolin" ]]; then
	echo "Katoolin created..."
	cd katoolin
	python katoolin.py
    else
	echo "Downloading Katoolin..."
	git clone https://github.com/LionSec/katoolin.git
	cd katoolin
	python katoolin.py
    fi
}

install_scripts() {
    echo
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
	apt_update
	apt_clean
    else
    	usage
    fi
}

main "$@"

