# Bootstrap entry point for aladd's dotfiles.
# macOS only for MVP. Linux support is on the roadmap (see .plans/).
#
# Quick start on a fresh Mac:
#   git clone <repo> ~/.dotfiles && cd ~/.dotfiles && make bootstrap
#
# Day-to-day:
#   make deps        # re-run after editing Brewfile
#   make link        # re-run after adding a new config file
#   make unlink      # remove the symlinks (configs revert to "not present")

SHELL := /usr/bin/env bash
DOTFILES_DIR := $(shell pwd)
HOMEBREW_INSTALL_URL := https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

.PHONY: help bootstrap brew deps link unlink relink post-install tpm fzf-tab fzf-shell cship doctor \
        uninstall uninstall-deps uninstall-clones uninstall-cship uninstall-state

help: ## show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Targets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

bootstrap: brew deps link post-install ## full setup: brew + deps + link + post-install
	@printf '\n\033[1;32m✓ bootstrap complete\033[0m — open a new shell or run: exec zsh -l\n'

brew: ## install Homebrew if missing
	@if command -v brew >/dev/null 2>&1; then \
	  echo "Homebrew already installed: $$(brew --version | head -n1)"; \
	else \
	  echo "Installing Homebrew..."; \
	  /bin/bash -c "$$(curl -fsSL $(HOMEBREW_INSTALL_URL))"; \
	fi

deps: ## install everything listed in Brewfile (idempotent)
	@command -v brew >/dev/null 2>&1 || { echo "brew not found — run 'make brew' first"; exit 1; }
	brew bundle install --file=$(DOTFILES_DIR)/Brewfile

link: ## stow this repo into $HOME (creates symlinks)
	@command -v stow >/dev/null 2>&1 || { echo "stow not found — run 'make deps' first"; exit 1; }
	stow --target=$$HOME --dir=$(dir $(DOTFILES_DIR)) --stow $(notdir $(patsubst %/,%,$(DOTFILES_DIR)))

unlink: ## remove the symlinks stow created
	@command -v stow >/dev/null 2>&1 || { echo "stow not found"; exit 1; }
	stow --target=$$HOME --dir=$(dir $(DOTFILES_DIR)) --delete $(notdir $(patsubst %/,%,$(DOTFILES_DIR)))

relink: unlink link ## unlink then re-stow (handy after rearranging files)

post-install: tpm fzf-tab fzf-shell cship ## run all non-brew bootstrap steps

tpm: ## clone tmux plugin manager and install declared plugins
	@TPM_DIR=$$HOME/.config/tmux/plugins/tpm; \
	  if [ -d $$TPM_DIR/.git ]; then echo "tpm already cloned"; \
	  else git clone https://github.com/tmux-plugins/tpm $$TPM_DIR; fi; \
	  $$TPM_DIR/bin/install_plugins || true

fzf-tab: ## clone Aloxaf/fzf-tab into ~/git-tools (path referenced by .aladd.zsh)
	@FZF_TAB_DIR=$$HOME/git-tools/fzf-tab; \
	  if [ -d $$FZF_TAB_DIR/.git ]; then echo "fzf-tab already cloned"; \
	  else mkdir -p $$HOME/git-tools && git clone https://github.com/Aloxaf/fzf-tab.git $$FZF_TAB_DIR; fi

fzf-shell: ## install fzf shell key-bindings + completion
	@INSTALLER="$$(brew --prefix)/opt/fzf/install"; \
	  if [ -x "$$INSTALLER" ]; then "$$INSTALLER" --all --no-update-rc; \
	  else echo "fzf installer not found — is fzf installed?" && exit 1; fi

cship: ## install cship (Claude Code statusline)
	curl -fsSL https://cship.dev/install.sh | bash

uninstall: ## clean-slate wipe: unlink + brew + clones + cship + tool state (FORCE=1 to skip prompt)
	@if [ "$$FORCE" != "1" ]; then \
	  printf '\033[1;33mThis will:\033[0m\n'; \
	  printf '  - run `make unlink` (remove stow symlinks)\n'; \
	  printf '  - `brew uninstall` every formula/cask listed in Brewfile (including apps like wezterm and karabiner-elements)\n'; \
	  printf '  - delete ~/.config/tmux/plugins and ~/git-tools/fzf-tab\n'; \
	  printf '  - remove the cship binary if found on PATH\n'; \
	  printf '  - wipe tool runtime state: nvim plugins/cache/shada, tmux resurrect, zoxide db, bat cache, yazi state\n'; \
	  printf 'Homebrew itself and macOS ~/Library app state are NOT removed.\n\n'; \
	  read -rp "Proceed? [y/N] " ans; \
	  case "$$ans" in y|Y|yes|YES) ;; *) echo "aborted."; exit 1 ;; esac; \
	fi
	@$(MAKE) unlink || true
	@$(MAKE) uninstall-deps
	@$(MAKE) uninstall-clones
	@$(MAKE) uninstall-cship
	@$(MAKE) uninstall-state
	@printf '\n\033[1;32m✓ uninstall complete\033[0m — run `make bootstrap` for a clean retry\n'

uninstall-deps: ## brew uninstall every formula+cask listed in Brewfile
	@command -v brew >/dev/null 2>&1 || { echo "brew not found — nothing to uninstall"; exit 0; }
	@echo "Uninstalling formulae from Brewfile..."
	@brew bundle list --formula --file=$(DOTFILES_DIR)/Brewfile 2>/dev/null \
	  | xargs -I{} sh -c 'brew uninstall --ignore-dependencies {} 2>/dev/null || echo "  (skipped {})"'
	@echo "Uninstalling casks from Brewfile..."
	@brew bundle list --cask --file=$(DOTFILES_DIR)/Brewfile 2>/dev/null \
	  | xargs -I{} sh -c 'brew uninstall --cask {} 2>/dev/null || echo "  (skipped {})"'

uninstall-clones: ## remove tpm + fzf-tab clone dirs
	@echo "Removing ~/.config/tmux/plugins ..."
	@rm -rf $$HOME/.config/tmux/plugins
	@echo "Removing ~/git-tools/fzf-tab ..."
	@rm -rf $$HOME/git-tools/fzf-tab
	@if [ -d $$HOME/git-tools ] && [ -z "$$(ls -A $$HOME/git-tools 2>/dev/null)" ]; then rmdir $$HOME/git-tools; fi

uninstall-cship: ## remove cship binary if installed
	@if command -v cship >/dev/null 2>&1; then \
	  CSHIP_BIN="$$(command -v cship)"; \
	  echo "Removing $$CSHIP_BIN"; rm -f "$$CSHIP_BIN"; \
	else echo "cship not on PATH — nothing to remove"; fi

uninstall-state: ## wipe tool runtime state (nvim plugins+cache+shada, tmux resurrect, zoxide db, bat cache, yazi state)
	@echo "Removing nvim runtime state (lazy plugins, mason LSPs, cache, shada)..."
	@rm -rf $$HOME/.local/share/nvim $$HOME/.local/state/nvim $$HOME/.cache/nvim
	@echo "Removing tmux runtime state (resurrect snapshots)..."
	@rm -rf $$HOME/.local/share/tmux
	@echo "Removing zoxide directory frecency db..."
	@rm -rf $$HOME/.local/share/zoxide
	@echo "Removing bat syntax cache..."
	@rm -rf $$HOME/.cache/bat
	@echo "Removing yazi state..."
	@rm -rf $$HOME/.local/state/yazi
	@echo "  (~/Library/Application Support entries for lazygit/karabiner/wezterm intentionally left alone)"

doctor: ## sanity check — list which expected tools are on PATH
	@printf '\nChecking PATH for expected tools (✓ found, ✗ missing):\n'
	@for cmd in brew stow bat eza fd rg fzf zoxide jq tmux nvim btop starship yazi lazygit op; do \
	  if command -v $$cmd >/dev/null 2>&1; then printf '  \033[32m✓\033[0m %s\n' $$cmd; \
	  else printf '  \033[31m✗\033[0m %s\n' $$cmd; fi; \
	done
	@printf '\nOptional / manual installs (informational only):\n'
	@for cmd in kubectl kubectx kubens minikube dotnet; do \
	  if command -v $$cmd >/dev/null 2>&1; then printf '  \033[32m✓\033[0m %s\n' $$cmd; \
	  else printf '  \033[2m·\033[0m %s (manual)\n' $$cmd; fi; \
	done
