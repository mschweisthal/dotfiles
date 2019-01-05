.PHONY: all
all: bin dotfiles etc

.PHONY: bin
bin: ## Installs the bin directory files.
	for file in $(shell find $(CURDIR)/bin -type f); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

.PHONY: etc
etc: ## Installs the etc directory files.
	for file in $(shell find $(CURDIR)/etc -type f); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo mkdir -p $$(dirname $$f); \
		sudo ln -f $$file $$f; \
	done
	systemctl --user daemon-reload || true
	sudo systemctl daemon-reload


.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	for file in $(shell find $(CURDIR) -name ".*"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done

