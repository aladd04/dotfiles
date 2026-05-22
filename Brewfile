# Brewfile — single source of truth for what `make bootstrap` installs.
#
# To skip a tool: comment out its line and re-run `make deps` (or `make bootstrap`).
# `brew bundle` is idempotent — already-installed packages are left alone.
# Disabling a line here does NOT uninstall — that requires `brew uninstall` manually
# (or opt in to `brew bundle cleanup`, which this Makefile does not run by default).
#
# Sections are alphabetical for scannability.

# ---- core CLI ---------------------------------------------------------------
brew "bat"                       # cat replacement, used as `cat` alias
brew "btop"                      # system monitor
brew "eza"                       # ls replacement, used as `ls` alias
brew "fastfetch"                 # system info / fetch tool
brew "fd"                        # find replacement, used by fzf for path gen
brew "fzf"                       # fuzzy finder (shell hooks installed in post-install)
brew "go"                        # runtime for Mason-installed Go LSPs/formatters (goimports, gofumpt)
brew "jq"                        # JSON tool, used by k8s helper functions
brew "lazygit"                   # git TUI
brew "neovim"                    # editor; LazyVim bootstraps itself on first launch
brew "node"                      # runtime + npm for Mason-installed JS/TS tools (bash-language-server, markdownlint-cli2, markdown-toc)
brew "python"                    # python 3.10+ for Mason-installed Python tools (sqlfluff); macOS-shipped 3.9 is too old
brew "ripgrep"                   # grep replacement, used as `grep` alias
brew "starship"                  # shell prompt
brew "stow"                      # symlink manager — used by `make link`
brew "tmux"                      # terminal multiplexer
brew "yazi"                      # terminal file manager
brew "zoxide"                    # cd replacement, used as `cd` alias
brew "zsh-autosuggestions"       # sourced in .aladd.zsh
brew "zsh-syntax-highlighting"   # sourced in .aladd.zsh

# ---- terminals (pick one) ---------------------------------------------------
# cask "ghostty"
cask "wezterm"

# ---- mac apps ---------------------------------------------------------------
cask "1password-cli"             # `op` — completion sourced in .aladd.zsh (distributed as cask, not formula)
cask "karabiner-elements"        # keyboard remapper, config in .config/karabiner/

# ---- intentionally NOT here -------------------------------------------------
# These are documented in README under "Manual installs / known gaps":
#   - font-monaspace-nerd-font  (user discretion)
#   - dotnet-sdk                (work setup)
#   - kubectl / kubectx / minikube (work setup)
