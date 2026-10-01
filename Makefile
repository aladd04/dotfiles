# Bootstrap entry point for aladd's dotfiles.
# macOS only for MVP. Linux support is on the roadmap (see .plans/).
#
# Prerequisites (one-time, before running anything in this file):
#   1. Install Homebrew  — see README "Prerequisites"
#   2. Install git via brew (or use the one that ships with Xcode CLT)
#   3. Clone this repo
#
# Quick start once prereqs are met:
#   cd ~/.dotfiles && make bootstrap
#
# Day-to-day:
#   make deps        # re-run after editing Brewfile
#   make link        # re-run after adding a new config file
#   make unlink      # remove the symlinks (configs revert to "not present")
#   make cship FORCE=1   # upgrade cship to the latest release

SHELL := /usr/bin/env bash
DOTFILES_DIR := $(shell pwd)
BREWFILE := $(DOTFILES_DIR)/Brewfile

.PHONY: help bootstrap deps link unlink relink zshrc post-install tpm fzf-tab fzf-shell mise-tools cship doctor \
	    fix-stow uninstall uninstall-deps uninstall-clones uninstall-cship uninstall-state

# ── output helpers ────────────────────────────────────────────────────────────
# Recipes are @-silenced; these print the progress instead so bootstrap reads as
# a checklist. Avoid commas inside $(call ...) arguments — make splits on them.
#   $(call step,<section title>)           blue "▶" header
#   $(call ok,<message>)                   green "✓" line
#   $(call note,<message>)                 dim "·" line
#   $(call quiet,<label>,<command>)        run <command> with output captured;
#                                          braille spinner while it runs (tty only),
#                                          "✓ label" on success, "✗ label" + the
#                                          captured output on failure (recipe fails)
step = printf '\n\033[1;34m▶ %s\033[0m\n' "$(1)"
ok   = printf '  \033[32m✓\033[0m %s\n' "$(1)"
note = printf '  \033[2m·\033[0m %s\n' "$(1)"
define quiet
LOG=$$(mktemp); ( $(2) ) >"$$LOG" 2>&1 & PID=$$!; \
if [ -t 1 ]; then SP=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏); I=0; \
  while kill -0 $$PID 2>/dev/null; do printf '\r  \033[36m%s\033[0m %s' "$${SP[I++ % 10]}" "$(1)"; sleep 0.1; done; \
  printf '\r\033[K'; fi; \
if wait $$PID; then $(call ok,$(1)); rm -f "$$LOG"; \
else printf '  \033[31m✗\033[0m %s\n' "$(1)"; sed 's/^/    /' "$$LOG"; rm -f "$$LOG"; exit 1; fi
endef

help: ## show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Targets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

bootstrap: ## full setup: deps + link + zshrc + post-install (requires brew + git already installed)
	@DEPS_FAILED=0; LINK_FAILED=0; \
	  $(MAKE) deps || DEPS_FAILED=1; \
	  $(MAKE) link || LINK_FAILED=1; \
	  $(MAKE) zshrc; \
	  $(MAKE) post-install; \
	  printf '\n'; \
	  if [ "$$DEPS_FAILED" = "1" ]; then printf '\033[1;33m⚠ some brew deps failed\033[0m — see the `deps` output above; fix Brewfile and rerun `make deps`\n'; fi; \
	  if [ "$$LINK_FAILED" = "1" ]; then printf '\033[1;33m⚠ stow link failed\033[0m — resolve conflicts and rerun `make link`\n'; fi; \
	  printf '\033[1;32m✓ bootstrap complete\033[0m — open a new shell or run: exec zsh -l\n'

deps: ## install everything listed in Brewfile (idempotent)
	@command -v brew >/dev/null 2>&1 || { echo "brew not found — see README \"Prerequisites\" before running this"; exit 1; }
	@$(call step,brew deps (Brewfile))
	@set -o pipefail; \
	  if OUT=$$(brew bundle check --file=$(BREWFILE) --verbose 2>&1); then \
	    $(call ok,all Brewfile deps already installed); \
	  else \
	    echo "$$OUT" | sed -n 's/^→ \(.*\) needs to be installed or updated\.$$/  · \1/p'; \
	    HOMEBREW_NO_ENV_HINTS=1 brew bundle install --file=$(BREWFILE) --quiet --verbose 2>&1 \
	      | { grep --line-buffered -v -E '^Skipping install of .* It is already installed\.$$' || true; }; \
	    $(call ok,Brewfile deps installed); \
	  fi

link: ## stow this repo into $HOME (creates symlinks)
	@command -v stow >/dev/null 2>&1 || { echo "stow not found — run 'make deps' first"; exit 1; }
	@$(call step,stow symlinks into ~)
	@stow --target=$$HOME --dir=$(DOTFILES_DIR) --stow .
	@$(call ok,linked)

unlink: ## remove the symlinks stow created
	@command -v stow >/dev/null 2>&1 || { echo "stow not found"; exit 1; }
	@stow --target=$$HOME --dir=$(DOTFILES_DIR) --delete .
	@$(call ok,stow symlinks removed)

relink: unlink link ## unlink then re-stow (handy after rearranging files)

fix-stow: ## remove known installer droppings in $HOME that block stow, then re-link
	@for f in $$HOME/.config/cship.toml $$HOME/.config/cship/sample-context.json; do \
	  if [ -e $$f ] && [ ! -L $$f ]; then \
	    echo "Removing real file blocking stow: $$f"; rm -f $$f; \
	  fi; \
	done
	@$(MAKE) link

zshrc: ## copy .zshrc-example to ~/.zshrc — only if ~/.zshrc doesn't already exist
	@$(call step,~/.zshrc)
	@if [ -e $$HOME/.zshrc ]; then \
	  $(call note,~/.zshrc already exists — leaving it alone (delete it manually if you want the example installed)); \
	else \
	  cp $(DOTFILES_DIR)/.zshrc-example $$HOME/.zshrc; \
	  $(call ok,copied .zshrc-example → ~/.zshrc); \
	fi

post-install: tpm fzf-tab fzf-shell mise-tools cship ## run all non-brew bootstrap steps

tpm: ## clone tpm + catppuccin/tmux, install TPM-declared plugins, source config in any running tmux
	@$(call step,tmux plugins (tpm))
	@TPM_DIR=$$HOME/.config/tmux/plugins/tpm; \
	  if [ -d $$TPM_DIR/.git ]; then $(call note,tpm already cloned); \
	  else $(call quiet,clone tpm,git clone -q https://github.com/tmux-plugins/tpm $$TPM_DIR); fi
	@CATP_DIR=$$HOME/.config/tmux/plugins/catppuccin/tmux; \
	  if [ -d $$CATP_DIR/.git ]; then $(call note,catppuccin/tmux already cloned); \
	  else mkdir -p $$HOME/.config/tmux/plugins/catppuccin && \
	    $(call quiet,clone catppuccin/tmux v2.3.0,git clone -q -b v2.3.0 https://github.com/catppuccin/tmux.git $$CATP_DIR); fi
	@TPM_DIR=$$HOME/.config/tmux/plugins/tpm; \
	  if tmux info >/dev/null 2>&1; then \
	    $(call quiet,install tpm plugins (running tmux server),$$TPM_DIR/bin/install_plugins); \
	    tmux source-file $$HOME/.tmux.conf 2>/dev/null || true; \
	    $(call ok,sourced ~/.tmux.conf in running tmux server); \
	  else \
	    tmux new-session -d -s _tpm_bootstrap 2>/dev/null || true; \
	    $(call quiet,install tpm plugins (transient tmux server),$$TPM_DIR/bin/install_plugins) \
	      || echo "    open tmux and press 'prefix + I' to install plugins manually"; \
	    tmux kill-session -t _tpm_bootstrap 2>/dev/null || true; \
	  fi

fzf-tab: ## clone Aloxaf/fzf-tab into ~/git-tools (path referenced by .aladd.zsh)
	@$(call step,fzf-tab)
	@FZF_TAB_DIR=$$HOME/git-tools/fzf-tab; \
	  if [ -d $$FZF_TAB_DIR/.git ]; then $(call note,fzf-tab already cloned); \
	  else mkdir -p $$HOME/git-tools && $(call quiet,clone fzf-tab,git clone -q https://github.com/Aloxaf/fzf-tab.git $$FZF_TAB_DIR); fi

fzf-shell: ## install fzf shell key-bindings + completion
	@$(call step,fzf shell hooks)
	@INSTALLER="$$(brew --prefix)/opt/fzf/install"; \
	  if [ -x "$$INSTALLER" ]; then $(call quiet,fzf key-bindings + completion (~/.fzf.zsh),"$$INSTALLER" --all --no-update-rc); \
	  else echo "fzf installer not found — is fzf installed?" && exit 1; fi

mise-tools: ## install tools declared in .config/mise/config.toml (node, dotnet, aspire) — needs `make link` first
	@command -v mise >/dev/null 2>&1 || { echo "mise not found — run 'make deps' first"; exit 1; }
	@$(call step,mise tools (node + dotnet + aspire))
	@[ -e $$HOME/.config/mise/config.toml ] || { echo "~/.config/mise/config.toml missing — run 'make link' first"; exit 1; }
	@set -o pipefail; mise install --yes 2>&1 | sed 's/^/  /'
	@mise ls --global 2>/dev/null | sed 's/^/  /'

# Installs the release binary directly instead of piping cship.dev/install.sh:
# the upstream installer uninstalls + re-downloads on every run, rewrites
# ~/.claude/settings.json, and ends with a full `cship explain` dump.
# cship.toml is stowed from this repo (.config/cship.toml), so only the binary
# and the statusLine entry in settings.json are handled here.
cship: ## install cship (Claude Code statusline); FORCE=1 re-downloads the latest release
	@$(call step,cship (Claude Code statusline))
	@BIN=$$HOME/.local/bin/cship; \
	  if [ -x "$$BIN" ] && [ "$$FORCE" != "1" ]; then \
	    $(call note,$$("$$BIN" --version) already installed — FORCE=1 to upgrade); \
	  else \
	    case "$$(uname -s)/$$(uname -m)" in \
	      Darwin/arm64)  T=aarch64-apple-darwin ;; \
	      Darwin/x86_64) T=x86_64-apple-darwin ;; \
	      Linux/x86_64)  T=x86_64-unknown-linux-musl ;; \
	      Linux/aarch64) T=aarch64-unknown-linux-musl ;; \
	      *) echo "unsupported platform: $$(uname -s)/$$(uname -m)"; exit 1 ;; \
	    esac; \
	    mkdir -p "$$(dirname "$$BIN")"; \
	    printf '  downloading cship-%s\n' "$$T"; \
	    curl -fL# -o "$$BIN.tmp" "https://github.com/stephenleo/cship/releases/latest/download/cship-$$T" \
	      && chmod +x "$$BIN.tmp" && mv "$$BIN.tmp" "$$BIN"; \
	    $(call ok,installed $$("$$BIN" --version) → $$BIN); \
	  fi
	@SETTINGS=$$HOME/.claude/settings.json; \
	  if [ -f "$$SETTINGS" ] && jq -e '.statusLine' "$$SETTINGS" >/dev/null 2>&1; then \
	    $(call note,statusLine already wired in ~/.claude/settings.json); \
	  else \
	    mkdir -p "$$(dirname "$$SETTINGS")"; [ -f "$$SETTINGS" ] || echo '{}' > "$$SETTINGS"; \
	    TMP=$$(mktemp); jq '.statusLine = {type: "command", command: "cship"}' "$$SETTINGS" > "$$TMP" && mv "$$TMP" "$$SETTINGS"; \
	    $(call ok,wired statusLine into ~/.claude/settings.json); \
	  fi

uninstall: ## clean-slate wipe: unlink + brew + clones + cship + tool state (FORCE=1 to skip prompt)
	@if [ "$$FORCE" != "1" ]; then \
	  printf '\033[1;33mThis will:\033[0m\n'; \
	  printf '  - run `make unlink` (remove stow symlinks)\n'; \
	  printf '  - `brew uninstall` every formula/cask listed in Brewfile (including apps like wezterm and karabiner-elements)\n'; \
	  printf '  - delete ~/.config/tmux/plugins and ~/git-tools/fzf-tab\n'; \
	  printf '  - remove the cship binary (~/.local/bin or PATH) and its statusLine entry in ~/.claude/settings.json\n'; \
	  printf '  - wipe tool runtime state: nvim plugins/cache/shada, tmux resurrect, zoxide db, bat cache, yazi state, mise runtimes\n'; \
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
	@brew bundle list --formula --file=$(BREWFILE) 2>/dev/null \
	  | xargs -I{} sh -c 'brew uninstall --ignore-dependencies {} 2>/dev/null || echo "  (skipped {})"'
	@echo "Uninstalling casks from Brewfile..."
	@brew bundle list --cask --file=$(BREWFILE) 2>/dev/null \
	  | xargs -I{} sh -c 'brew uninstall --cask {} 2>/dev/null || echo "  (skipped {})"'

uninstall-clones: ## remove tpm + fzf-tab clone dirs
	@echo "Removing ~/.config/tmux/plugins ..."
	@rm -rf $$HOME/.config/tmux/plugins
	@echo "Removing ~/git-tools/fzf-tab ..."
	@rm -rf $$HOME/git-tools/fzf-tab
	@if [ -d $$HOME/git-tools ] && [ -z "$$(ls -A $$HOME/git-tools 2>/dev/null)" ]; then rmdir $$HOME/git-tools; fi

uninstall-cship: ## remove the cship binary + its statusLine entry in ~/.claude/settings.json
	@REMOVED=0; \
	  for BIN in "$$HOME/.local/bin/cship" "$$(command -v cship 2>/dev/null)"; do \
	    if [ -n "$$BIN" ] && [ -f "$$BIN" ]; then echo "Removing $$BIN"; rm -f "$$BIN"; REMOVED=1; fi; \
	  done; \
	  [ "$$REMOVED" = "1" ] || echo "cship binary not found — nothing to remove"
	@SETTINGS=$$HOME/.claude/settings.json; \
	  if [ -f "$$SETTINGS" ] && [ "$$(jq -r '.statusLine.command // empty' "$$SETTINGS" 2>/dev/null)" = "cship" ]; then \
	    TMP=$$(mktemp); jq 'del(.statusLine)' "$$SETTINGS" > "$$TMP" && mv "$$TMP" "$$SETTINGS"; \
	    echo "Removed statusLine entry from $$SETTINGS"; \
	  fi

uninstall-state: ## wipe tool runtime state (nvim plugins+cache+shada, tmux resurrect, zoxide db, bat cache, yazi state, mise runtimes)
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
	@echo "Removing mise-managed tools (node, dotnet, aspire) and cache..."
	@rm -rf $$HOME/.local/share/mise $$HOME/.local/state/mise $$HOME/.cache/mise
	@echo "  (~/Library/Application Support entries for lazygit/karabiner/wezterm intentionally left alone)"

doctor: ## sanity check — list which expected tools are on PATH
	@printf '\nChecking PATH for expected tools (✓ found, ✗ missing):\n'
	@export PATH="$$HOME/.local/share/mise/shims:$$PATH"; \
	  for cmd in brew git stow bat eza fd rg fzf zoxide jq tmux nvim btop starship yazi lazygit fastfetch op mise node npm dotnet go python3 ruby cship \
	             az kubectl kubectx kubens helm redis-cli sqlcmd aspire; do \
	  if command -v $$cmd >/dev/null 2>&1; then printf '  \033[32m✓\033[0m %s\n' $$cmd; \
	  else printf '  \033[31m✗\033[0m %s\n' $$cmd; fi; \
	done
