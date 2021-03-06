#!/bin/bash


clear_ipv4() {

  iptables -P INPUT ACCEPT
  iptables -P OUTPUT ACCEPT
  iptables -P FORWARD ACCEPT
  
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  iptables -t nat -F
  iptables -t mangle -F
  iptables -F
  iptables -X
}

setup_ipv4() {
  iptables -P INPUT DROP
  iptables -P OUTPUT DROP
  iptables -P FORWARD DROP
  
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  iptables -A INPUT -m pkttype --pkt-type multicast -j DROP
  iptables -A OUTPUT -m pkttype --pkt-type multicast -j DROP
  iptables -A INPUT -m pkttype --pkt-type broadcast -j DROP
  iptables -A OUTPUT -m pkttype --pkt-type broadcast -j DROP
  
  iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
  iptables -A OUTPUT -m state --state NEW,ESTABLISHED -j ACCEPT
}

clear_ipv6() {
  ip6tables -P INPUT ACCEPT
  ip6tables -P OUTPUT ACCEPT
  ip6tables -P FORWARD ACCEPT
  
  ip6tables -A INPUT -i lo -j ACCEPT
  ip6tables -A OUTPUT -o lo -j ACCEPT

  ip6tables -t nat -F
  ip6tables -t mangle -F
  ip6tables -F
  ip6tables -X
}

setup_ipv6() {
  ip6tables -P INPUT DROP
  ip6tables -P OUTPUT DROP
  ip6tables -P FORWARD DROP

  ip6tables -A INPUT -i lo -j ACCEPT
  ip6tables -A OUTPUT -o lo -j ACCEPT

  ip6tables -A INPUT -m state --state ESTABLISHED -j ACCEPT
  ip6tables -A OUTPUT -m state --state NEW,ESTABLISHED -j ACCEPT
}

clear_arp() {
  arptables -P INPUT ACCEPT
  arptables -P OUTPUT ACCEPT
#  arptables -P FORWARD ACCEPT
  
  arptables -t mangle -F
  arptables -F
  arptables -X
}

setup_arp() {
  arptables -P INPUT DROP
  arptables -P OUTPUT DROP
#  arptables -P FORWARD DROP

  arptables -A INPUT --source-mac 70:4f:b8:7e:de:11 -j ACCEPT
  arptables -A OUTPUT --destination-mac 70:4f:b8:7e:de:11 -j ACCEPT
}

drop() {
  iptables -P INPUT DROP
  iptables -P OUTPUT DROP
  iptables -P FORWARD DROP

  ip6tables -P INPUT DROP
  ip6tables -P OUTPUT DROP
  ip6tables -P FORWARD DROP
  
  arptables -P INPUT DROP
  arptables -P OUTPUT DROP
}

usage() {
  echo "Usage:"
  echo "  ipv4-off - disable ipv4 traffic"
  echo "  ipv4-on  - enable ipv4 traffic"
  echo "  ipv4-off - disable ipv6 traffic"
  echo "  ipv4-on  - enable ipv6 traffic"
  echo "  arp-on   - enable arp for specific MAC only"
  echo "  arp-off  - enable all arp"
  echo
  echo "  on       - enable all"
  echo "  default  - default all"
  echo "  drop     - drop all"
}

main() {
  local cmd=$1
  if [[ -z "$cmd" ]]; then
    usage
    exit 1
  fi
  
  if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root"
	exit 1
  fi
  
  if [[ $cmd == "ipv4-on" ]]; then
    setup_ipv4
  elif [[ $cmd == "ipv4-off" ]]; then
    clear_ipv4
  elif [[ $cmd == "ipv6-on" ]]; then
    setup_ipv6
  elif [[ $cmd == "ipv6-off" ]]; then
    clear_ipv6
  elif [[ $cmd == "arp-on" ]]; then
    setup_arp
  elif [[ $cmd == "arp-off" ]]; then
    clear_arp
  elif [[ $cmd == "on" ]]; then
    echo "Enabling all..."
    clear_ipv4
    clear_ipv6
    clear_arp
    setup_arp
    setup_ipv4
    setup_ipv6
  elif [[ "$cmd" == "default" ]]; then
    echo "Setting to default..."
    clear_ipv4
    clear_ipv6
    clear_arp
  elif [[ "$cmd" == "drop" ]]; then
    echo "Dropping all..."
    clear_ipv4
    clear_ipv6
    clear_arp
    drop
  fi
  
  echo "Done."
}

main "$@"

