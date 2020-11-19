# Programs
alias ff='~/bin/firefox/firefox &'
alias ffkill="ps ux | grep firefox | grep childID | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
alias tb='cd ~/bin/tor-browser_en-US/; ./start-tor-browser.desktop; cd ~'
alias chess8='xboard -size medium -fUCI -fcp stockfish -sUCI -scp stockfish'
alias chess10='xboard -size medium -fUCI -fcp /usr/games/stockfish_10_x64 -sUCI -scp /usr/games/stockfish_10_x64'

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi
# List all files colorized in long format
alias l="ls -lhF ${colorflag}"
# List all files colorized in long format, including dot files
alias la="ls -lahF ${colorflag}"
# List all files colorized in long format, including dot files, most recently written last
alias ltr="ls -ltrahF ${colorflag}"
# List only directories
alias lsd="ls -lhF ${colorflag} | grep --color=never '^d'"
# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Copy to clipboard 
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
# Trim new lines and copy to clipboard
alias c="tr -d '\\n' | xclip -selection clipboard"

# Always enable colored `grep` output
alias grep='grep --color=auto '
alias egrep='egrep --color=auto '
alias fgrep='fgrep --color=auto '

# Enable aliases to be sudo’ed
alias sudo='sudo '
alias root='sudo -i'

# Time 
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Math
alias bc='bc -l'

# Diff
alias diff='colordiff'

# copy working directory
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

# interactive
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

alias rm='rm -I --preserve-root'

# untar
alias untar='tar xvf'

### NET
alias wget='wget -c'

# Ping
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'

# IPTables
alias iptlist='sudo /sbin/iptables -nvL --line-numbers'
alias iptlistin='sudo /sbin/iptables -nv -L INPUT --line-numbers'
alias iptlistout='sudo /sbin/iptables -nv -L OUTPUT --line-numbers'
alias iptlistfw='sudo /sbin/iptables -nv -L FORWARD --line-numbers'
#IP6Tables
alias ip6list='sudo /sbin/ip6tables -nvL --line-numbers'
#ArpTables
alias aptlist='sudo /sbin/arptables -nvL --line-numbers'
alias fwlist='iptlist && ip6list &&  aptlist'

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Ports
alias ports='netstat -tulanp'

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""

# Debug web server / cdn problems
alias header='curl -I'
alias headerc='curl -I --compress'

# vhosts
alias hosts='sudo vim /etc/hosts'

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"


# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m \"$method\""
done

alias weather='curl wttr.in/"west palm beach"'
alias usbon='sudo modprobe usbhid'
alias usboff='sudo modprobe -r hid_logitech_dj usbhid'
