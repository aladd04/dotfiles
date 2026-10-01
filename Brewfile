# Brewfile — single source of truth for what `make bootstrap` installs.
#
# To skip a tool: comment out its line and re-run `make deps` (or `make bootstrap`).
# `brew bundle` is idempotent — already-installed packages are left alone.
# Disabling a line here does NOT uninstall — that requires `brew uninstall` manually
# (or opt in to `brew bundle cleanup`, which this Makefile does not run by default).
#
# Sections are alphabetical for scannability.

# ---- taps -------------------------------------------------------------------
tap 'microsoft/aspire'           # Aspire CLI cask (https://aspire.dev/get-started/install-cli/)

# ---- core CLI ---------------------------------------------------------------
brew 'bat'                       # cat replacement, used as `cat` alias
brew 'btop'                      # system monitor
brew 'eza'                       # ls replacement, used as `ls` alias
brew 'fastfetch'                 # system info / fetch tool
brew 'fd'                        # find replacement, used by fzf for path gen
brew 'fzf'                       # fuzzy finder (shell hooks installed in post-install)
brew 'go'                        # runtime for Mason-installed Go LSPs/formatters (goimports, gofumpt)
brew 'herdr'                     # AI native terminal multiplexer
brew 'jq'                        # JSON tool, used by k8s helper functions
brew 'lazygit'                   # git TUI
brew 'neovim'                    # editor; LazyVim bootstraps itself on first launch
brew 'mise'                      # runtime version manager — installs node + dotnet (see .config/mise/config.toml)
brew 'python'                    # python 3.10+ for Mason-installed Python tools (sqlfluff); macOS-shipped 3.9 is too old
brew 'ripgrep'                   # grep replacement, used as `grep` alias
brew 'ruby'                      # ruby 3.x for Mason-installed Ruby tools (erb-lint, erb-formatter); macOS-shipped 2.6 is too old. Keg-only — see PATH shim in .aladd.zsh
brew 'sevenzip'                  # 7zip for unpacking
brew 'starship'                  # shell prompt
brew 'stow'                      # symlink manager — used by `make link`
brew 'tmux'                      # terminal multiplexer
brew 'yazi'                      # terminal file manager
brew 'zoxide'                    # cd replacement, used as `cd` alias
brew 'zsh-autosuggestions'       # sourced in .aladd.zsh
brew 'zsh-syntax-highlighting'   # sourced in .aladd.zsh

# ---- terminals (pick one) ---------------------------------------------------
# cask "ghostty"
# cask 'wezterm'

# ---- fonts ------------------------------------------------------------------
cask 'font-monaspace'            # base Monaspace family
cask 'font-monaspice-nerd-font'  # Nerd Font variant — what wezterm/ghostty configs reference ("MonaspiceNe Nerd Font")

# ---- mac apps ---------------------------------------------------------------
cask '1password-cli'             # `op` — completion sourced in .aladd.zsh (distributed as cask, not formula)
cask 'betterdisplay'             # macOS tool to handle display stuff better
cask 'git-credential-manager'    # secure cross-platform git credential helper (distributed as cask, not formula)
cask 'karabiner-elements'        # keyboard remapper, config in .config/karabiner/

# ---- AI tools ---------------------------------------------------------------
cask 'claude-code@latest'
cask 'codex'

# ---- cloud / k8s / data -----------------------------------------------------
# Mostly used on the work machine, but installed everywhere — one Brewfile is
# easier to maintain than work/personal variants, and unused tools cost nothing.
# Configuring these (az login, az devops defaults, kube contexts) is still a
# manual step — see README "Manual configuration".
cask 'microsoft/aspire/aspire'   # `aspire` — .NET Aspire CLI (cask from Microsoft's tap, not homebrew-core)
brew 'azure-cli'                 # `az` — Azure CLI; `az devops` extension added manually (see README)
brew 'helm'                      # Kubernetes package manager
brew 'kubernetes-cli'            # `kubectl` — aliases (k) + fzf helpers in .aladd.zsh, completion sourced when present
brew 'kubectx'                   # `kubectx` / `kubens` — context + namespace switchers, aliased kc / kn in .aladd.zsh
brew 'redis'                     # `redis-cli` (+ redis-server; start locally with `brew services start redis` if needed)
brew 'sqlcmd'                    # `sqlcmd` — Microsoft SQL Server CLI (go-sqlcmd)

# node and dotnet are managed by mise, not brew — see .config/mise/config.toml
