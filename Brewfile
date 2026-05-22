# Brewfile — single source of truth for what `make bootstrap` installs.
#
# To skip a tool: comment out its line and re-run `make deps` (or `make bootstrap`).
# `brew bundle` is idempotent — already-installed packages are left alone.
# Disabling a line here does NOT uninstall — that requires `brew uninstall` manually
# (or opt in to `brew bundle cleanup`, which this Makefile does not run by default).

# ---- core CLI ---------------------------------------------------------------
brew "bat"                       # cat replacement, used as `cat` alias
brew "eza"                       # ls replacement, used as `ls` alias
brew "fd"                        # find replacement, used by fzf for path gen
brew "ripgrep"                   # grep replacement, used as `grep` alias
brew "fzf"                       # fuzzy finder (shell hooks installed in post-install)
brew "zoxide"                    # cd replacement, used as `cd` alias
brew "jq"                        # JSON tool, used by k8s helper functions
brew "stow"                      # symlink manager — used by `make link`
brew "tmux"                      # terminal multiplexer
brew "neovim"                    # editor; LazyVim bootstraps itself on first launch
brew "btop"                      # system monitor
brew "starship"                  # shell prompt
brew "yazi"                      # terminal file manager
brew "lazygit"                   # git TUI
brew "zsh-autosuggestions"       # sourced in .aladd.zsh
brew "zsh-syntax-highlighting"   # sourced in .aladd.zsh
brew "1password-cli"             # `op` — completion sourced in .aladd.zsh

# ---- terminals (pick one) ---------------------------------------------------
cask "wezterm"
# cask "ghostty"

# ---- mac apps ---------------------------------------------------------------
cask "karabiner-elements"        # keyboard remapper, config in .config/karabiner/

# ---- intentionally NOT here -------------------------------------------------
# These are documented in README under "Manual installs / known gaps":
#   - font-monaspace-nerd-font  (user discretion)
#   - dotnet-sdk                (work setup)
#   - kubectl / kubectx / minikube (work setup)
