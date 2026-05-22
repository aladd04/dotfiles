aladd04's dotfiles

## Quick start (fresh macOS)

```
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
make bootstrap
```

That runs, in order:
1. `make brew` — installs Homebrew if missing
2. `make deps` — `brew bundle install --file=Brewfile`
3. `make link` — `stow` this repo into `$HOME`
4. `make post-install` — clones tpm + fzf-tab, wires fzf shell hooks, installs cship

Then open a new shell:
```
exec zsh -l
```

`make help` lists every target. `make doctor` shows which expected tools are on PATH.

## Enabling / disabling tools

Open `Brewfile` and comment out the line for any tool you don't want. Then:
```
make deps
```
Already-installed packages are left alone; commenting a line does **not** uninstall — run `brew uninstall <pkg>` manually if you want it gone.

Example — switching from wezterm to ghostty:
```ruby
# cask "wezterm"
cask "ghostty"
```

## After pulling new config

`make link` is idempotent — re-run it any time you add a new file under `.config/` or a new top-level dotfile, and stow will create the new symlinks.

If you ever want to undo: `make unlink`.

After pulling, also source the custom zsh config in your current shell:
```
source ~/.aladd.zsh
```

## Manual installs / known gaps

The Makefile deliberately does **not** install these — they're personal-preference or work-environment dependent.

- **MonaspiceNe Nerd Font** — referenced by `.wezterm.lua` and `.config/ghostty/config`. Install via the [Nerd Fonts](https://www.nerdfonts.com/) downloads, or `brew install --cask font-monaspace-nerd-font`.
- **dotnet SDK** — `.aladd.zsh` wires up `dotnet` zsh completion. Without `dotnet` on PATH, you'll see a "command not found" warning on shell startup.
- **Kubernetes tooling** (`kubectl`, `kubectx`/`kubens`, `minikube`) — `.aladd.zsh` defines aliases (`k`, `kc`, `kn`, `mk`) and sources `kubectl completion zsh`. Install from work onboarding or `brew install kubectl kubectx minikube` to enable them.
- **LazyVim plugins** — `nvim` self-bootstraps `lazy.nvim` on first launch. Just open `nvim`.
- **iTerm2** — `iterm2/` in this repo holds a legacy color-scheme export. Current default terminal is wezterm.

## Layout

```
.dotfiles/
├── Makefile               # bootstrap entry point (`make help`)
├── Brewfile               # toggle tools by commenting lines
├── .stow-local-ignore     # what stow skips
├── .plans/                # committed plan artifacts (not stowed)
├── .config/               # XDG configs (stowed into ~/.config)
├── .aladd.zsh             # custom zsh sourced from ~/.zshrc
├── .tmux.conf             # loads .config/tmux/tmux.conf
├── .vimrc, .wezterm.lua   # other root-level dotfiles
└── iterm2/                # legacy color export — not stowed
```

## Roadmap

- Linux support (apt/dnf/pacman branches keyed off `uname -s`)
- Optional `make work` target for the manually-installed tools above
- Guard `.aladd.zsh` completion sourcing on `command -v` so missing tools don't warn
