#!/bin/bash

# Load .bashrc and other files...
for file in ~/.{bashrc,bash_aliases,functions,path,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file
