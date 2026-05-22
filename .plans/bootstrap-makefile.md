# Bootstrap Makefile for dotfiles (macOS MVP)

## Context

The repo currently holds zsh, tmux, nvim, and other tool configs, but there's no automation to install the tools those configs depend on. On a fresh Mac, the user has to manually install bat, eza, fd, fzf, etc. before any of this works — and remember which terminal/font/etc. they actually want this time around.

Goal: a single `make bootstrap` that installs everything referenced by `.aladd.zsh` and `.config/*`, symlinks the dotfiles into `$HOME`, and lets the user opt out of individual tools by commenting one line in a `Brewfile`. macOS only for MVP; Linux comes later.

## Tool inventory (what gets installed)

Derived from `.aladd.zsh`, `.config/**`, `.tmux.conf`, `.wezterm.lua`, `.vimrc`.

**Core CLI (brew formulae):**
- `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `zoxide`, `jq`, `stow`
- `tmux`, `neovim`, `btop`, `starship`, `yazi`, `lazygit`
- `zsh-autosuggestions`, `zsh-syntax-highlighting`
- `1password-cli` (sourced by `.aladd.zsh`)

**GUI / casks (terminal + mac apps):**
- `wezterm` (current default)
- `ghostty` (commented out — alternative terminal, user can swap)
- `karabiner-elements` (mac-only; config exists at `.config/karabiner/`)

**Non-brew steps:**
- Homebrew itself (bootstrap if missing)
- `fzf` shell integration: `"$(brew --prefix)"/opt/fzf/install --all --no-update-rc`
- `tpm` clone → `~/.config/tmux/plugins/tpm` (then `bin/install_plugins` pulls catppuccin + others from `.config/tmux/tmux.conf`)
- `fzf-tab` clone → `~/git-tools/fzf-tab` (path hardcoded in `.aladd.zsh:359`)
- `cship`: `curl -fsSL https://cship.dev/install.sh | bash`

**Deliberately NOT installed by the Makefile (documented, user installs manually):**
- MonaspiceNe Nerd Font — referenced by `.wezterm.lua` and `.config/ghostty/config`
- `dotnet` SDK — `.aladd.zsh:411-426` wires up completion
- k8s tooling: `kubectl`, `kubectx`, `kubens`, `minikube` — `.aladd.zsh` has aliases + completion sourcing
- LazyVim plugin set — bootstraps itself on first `nvim` launch via `lazy.nvim`
- iTerm2 — legacy; `iterm2/` folder remains for the color-scheme export, but wezterm is current

## Approach

**Install vector: Homebrew + Brewfile, driven by Make.**
- `Brewfile` at repo root uses native Homebrew syntax (`brew "..."`, `cask "..."`, `tap "..."`). Enable/disable = comment the line. `brew bundle install --file=Brewfile` is idempotent and well-understood.
- `Makefile` at repo root orchestrates the rest: bootstrap Homebrew if missing, run `brew bundle`, run `stow`, then post-install steps (tpm, fzf-tab, fzf shell hooks, cship).

**Symlink vector: GNU stow.**
- Repo already has `.stow-local-ignore`, so it's stow-shaped. `stow` is added to the Brewfile so a fresh box installs it before the link step.
- We extend `.stow-local-ignore` to also skip the new bootstrap files (`Makefile`, `Brewfile`, `scripts`, `.plans`, `iterm2`) so they don't get linked into `$HOME`.

**Idempotency:**
- `brew bundle install` skips already-installed packages.
- Git-clone steps guard with `[ -d <dir> ] || git clone ...`.
- `cship` install script is re-runnable per its upstream behavior.
- `stow -t $HOME .` will refuse if a real file already exists; user is expected to back up beforehand on an existing machine. On a truly fresh Mac, no conflicts.

## File structure

```
.dotfiles/
├── Makefile             # new — entry point
├── Brewfile             # new — single source of truth for tool toggles
├── scripts/
│   └── post-install.sh  # new — tpm/fzf-tab/cship/fzf-shell steps
├── .plans/              # new — committed plan artifacts, stow-ignored
├── .stow-local-ignore   # modified — add Makefile, Brewfile, scripts, .plans, iterm2
├── README.md            # modified — usage + manual-install callouts
└── … (existing config tree unchanged)
```

Single source of toggling = the `Brewfile`. The user comments one line to skip wezterm/ghostty/karabiner/etc. Non-brew items (tpm, fzf-tab, cship) are all small and always-on; if the user truly doesn't want them they can omit `make post-install`.

## Makefile targets

```
make help          # default — print targets
make bootstrap     # full: brew → deps → link → post-install
make brew          # install Homebrew if missing
make deps          # brew bundle install --file=Brewfile
make link          # stow -t $HOME .
make unlink        # stow -D -t $HOME .   (for tearing down)
make post-install  # tpm + fzf-tab + fzf-shell + cship
make tpm           # clone tpm, run install_plugins
make fzf-tab       # clone Aloxaf/fzf-tab into ~/git-tools
make fzf-shell     # run fzf's install --all --no-update-rc
make cship         # curl | bash the cship installer
```

`bootstrap` is the only target a fresh-machine user normally runs. Each sub-target is independently re-runnable.

## Brewfile (illustrative shape — final file lives at repo root)

```ruby
# Comment out a line to skip installing that tool.

# core CLI
brew "bat"
brew "eza"
brew "fd"
brew "ripgrep"
brew "fzf"
brew "zoxide"
brew "jq"
brew "stow"
brew "tmux"
brew "neovim"
brew "btop"
brew "starship"
brew "yazi"
brew "lazygit"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "1password-cli"

# terminals (pick one)
cask "wezterm"
# cask "ghostty"

# mac apps
cask "karabiner-elements"
```

## README additions (call out the discrepancies)

A short "Manual installs / known gaps" section:
- `.aladd.zsh` sources `dotnet complete` and `op completion zsh` — if `dotnet` or `op` is missing on a given machine, you'll see "command not found" on shell startup until they're installed (or until those lines are guarded).
- MonaspiceNe Nerd Font is referenced by wezterm and ghostty configs — install via Nerd Fonts download or `brew install --cask font-monaspace-nerd-font` at your discretion.
- k8s tooling (`kubectl`, `kubectx`, `minikube`) is expected to come from work onboarding, not this repo.
- `dotnet` SDK is your choice per-machine.
- LazyVim self-bootstraps on first `nvim` launch — no Makefile step needed.

## Verification

1. **Dry run on current machine:** `make deps` should report everything already installed. `make link` should refuse cleanly where conflicts exist.
2. **Fresh-state simulation:** in a throwaway macOS VM (or a new user account), clone the repo and run `make bootstrap`. Then:
   - `exec zsh -l` — no "command not found" errors except for the explicitly-skipped tools (dotnet, kubectl, etc.).
   - `which bat eza fd rg fzf zoxide starship yazi lazygit tmux nvim btop` — all resolve.
   - Launch `tmux` → confirm catppuccin status line renders (tpm pulled the theme).
   - Launch `nvim` → LazyVim downloads plugins on first run.
   - `wezterm` opens with the Monaspace font (after manually installing the font per docs).
3. **Toggle test:** comment `cask "wezterm"` and uncomment `cask "ghostty"` in `Brewfile`, rerun `make deps` — wezterm stays installed (brew bundle doesn't uninstall by default), ghostty gets added. Confirms the toggle is the only edit point.

## Out of scope (future)

- Linux support (apt/dnf/pacman branches keyed off `uname -s`); Brewfile can stay since linuxbrew works, but cask entries need guards.
- Auto-removal of disabled tools (would require `brew bundle cleanup`, opt-in).
- Bootstrapping work-machine items (dotnet, k8s, fonts) behind a `make work` target.
