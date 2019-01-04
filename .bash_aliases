if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# Programs
alias ff='~/bin/firefox-65.0b2/firefox &'
alias tb='cd ~/bin/tor-browser_en-US/; ./start-tor-browser.desktop; cd ~'
alias chess8='xboard -size medium -fUCI -fcp stockfish -sUCI -scp stockfish'
alias chess10='xboard -size medium -fUCI -fcp /usr/games/stockfish_10_x64 -sUCI -scp /usr/games/stockfish_10_x64'

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# Shortcuts
alias gc=". /usr/local/bin/gitdate && git commit -v "

# List all files colorized in long format
alias l="ls -lhF ${colorflag}"
# List all files colorized in long format, including dot files
alias la="ls -lahF ${colorflag}"
# List only directories
alias lsd="ls -lhF ${colorflag} | grep --color=never '^d'"
# Always use color output for `ls`
alias ls="command ls ${colorflag}"

