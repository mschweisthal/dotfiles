.PHONY: all
all: bin dotfiles

.PHONY: bin
bin: ## Installs the bin directory files.
	for file in $(shell find $(CURDIR)/bin -type f); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done; 

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	for file in $(shell find $(CURDIR) -name ".*"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

