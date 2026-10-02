aladd04's dotfiles

## Prerequisites (fresh macOS)

The Makefile can't bootstrap Homebrew or git itself — you need both before you can even clone this repo and read the Brewfile. Run these three steps manually first:

**1. Install Homebrew.** From [brew.sh](https://brew.sh):
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Add Homebrew to your shell PATH.** The Homebrew installer prints the exact commands at the end — typically:
```
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**3. Install git.**
```
brew install git
```
(The Xcode Command Line Tools that Homebrew pulls in also include a `git`, but installing it via brew keeps it managed alongside everything else and is what we use going forward.)

## Quick start

```
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
make bootstrap
```

That runs, in order:
1. `make deps` — `brew bundle install --file=Brewfile`
2. `make link` — `stow` this repo into `$HOME`
3. `make zshrc` — copies `.zshrc-example` → `~/.zshrc` if no `~/.zshrc` exists (won't clobber an existing one)
4. `make post-install` — clones tpm + fzf-tab, wires fzf shell hooks, installs mise-managed tools (node, dotnet, aspire), installs cship

Every step prints a `▶` header and a `✓` / `·` result line. Brew output streams directly to the terminal, and tap clones show Git's live transfer progress (percent, bytes, and speed). Large tap histories can take several minutes to download. The progress helper applies only during `make deps` / `make bootstrap`; redirected runs keep ordinary Git output. cship is downloaded straight from its GitHub release (no `install.sh`), and is skipped once installed — `make cship FORCE=1` upgrades it to the latest release.

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

If you want to undo just the symlinks: `make unlink`.

## Troubleshooting: "stow link failed" / `make bootstrap` partially worked

If a previous bootstrap ran post-install steps before stow successfully created symlinks (e.g. because deps or link failed mid-run), some installers drop real files at the same paths the repo wants to symlink. Stow then refuses to overwrite them and aborts. (Older versions of this Makefile ran cship's upstream `install.sh`, which did exactly that with `~/.config/cship.toml`.)

Quick fix:
```
make fix-stow
```
That removes the known installer droppings (`~/.config/cship.toml`, `~/.config/cship/sample-context.json`) and re-runs `make link`. Then `make bootstrap` again to finish anything still pending.

## Clean-slate uninstall (try again)

If a bootstrap didn't go right and you want to retry from scratch:
```
make uninstall            # prompts for confirmation
make uninstall FORCE=1    # skip the prompt
```
That removes the stow symlinks, `brew uninstall`s everything in `Brewfile` (including casks like wezterm/karabiner — their app binaries go with them), deletes the tpm + fzf-tab clones, removes the `cship` binary and its `statusLine` entry in `~/.claude/settings.json`, and wipes tool-level runtime state (nvim plugins/Mason LSPs/cache/shada, tmux resurrect, zoxide db, bat cache, yazi state). Homebrew itself and macOS `~/Library/Application Support/*` entries are left alone — if you want a true factory reset of karabiner/wezterm/lazygit app state, remove those manually.

Selective wipes if you only want part of it:
- `make uninstall-deps` — only the Brewfile packages
- `make uninstall-clones` — only the tpm + fzf-tab dirs
- `make uninstall-cship` — only cship
- `make uninstall-state` — only tool runtime state (nvim cache, mise runtimes, etc.)

After pulling, also source the custom zsh config in your current shell:
```
source ~/.aladd.zsh
```

## Runtimes (mise)

`node`, `dotnet` and the `aspire` CLI are managed by [mise](https://mise.jdx.dev), not brew. Versions live in `.config/mise/config.toml` (stowed to `~/.config/mise/config.toml`); `make mise-tools` runs `mise install` against it. `.aladd.zsh` activates mise and puts its shims on PATH so non-interactive processes (nvim/Mason, Claude Code) find the runtimes too.

- Bump a version: edit `config.toml`, then `mise install`
- Per-project version: `mise use node@22` or `mise use aspire@13.5.4` in that directory (writes `mise.toml`); `.nvmrc` / `.node-version` are honored too
- See what's active: `mise ls`

## Manual configuration

Everything is installed by `make bootstrap` — there's no separate work/personal variant. The cloud / k8s / data tools (`az`, `kubectl`, `kubectx`, `kubelogin`, `helm`, `redis`, `sqlcmd`) are in the Brewfile, the `aspire` CLI comes from mise, and all of it lands on every machine; what's left is signing in and pointing them at the right place, which this repo can't do for you.

- **Git identity + credentials** — nothing in this repo stows a `.gitconfig`, so set these once per machine:
  ```
  git config --global user.name  "Andy Ladd"
  git config --global user.email "aladd04@gmail.com"
  git-credential-manager configure            # wires the GCM cask from the Brewfile in as credential.helper
  git config --global credential.https://dev.azure.com.useHttpPath true   # GCM needs this for Azure DevOps repos
  ```
  To use a different email for work repos without changing the global one, add a conditional include — e.g. `git config --global includeIf."gitdir:~/work/".path ~/.gitconfig-work`, with `~/.gitconfig-work` holding just a `[user] email = ...` block.
- **Azure CLI** (`az`)
  ```
  az login                                    # Entra sign-in; preferred over a PAT
  ```
- **Azure DevOps CLI** (`az devops`, `az repos`, `az pipelines`, `az boards`, `az artifacts`) — an extension on top of the Azure CLI ([docs](https://learn.microsoft.com/en-us/azure/devops/cli/)). Cloud Azure DevOps Services only, not on-prem Server.
  ```
  az extension add --name azure-devops        # or: az extension update --name azure-devops
  az devops configure --defaults organization=https://dev.azure.com/<org> project=<project>
  az devops --help                            # sanity check; `--open` on most show commands opens the item in a browser
  ```
- **Kubernetes** (`kubectl`, `kubectx`/`kubens`, `kubelogin`, `helm`) — get a kubeconfig from work onboarding, e.g. `az aks get-credentials -g <rg> -n <cluster>` followed by `kubelogin convert-kubeconfig -l azurecli` so kubectl reuses your `az login` session. `.aladd.zsh` defines aliases (`k`, `kc`, `kn`) plus fzf-powered pod/log helpers, and sources `kubectl completion zsh` when `kubectl` is present.
- **Redis** — only `redis-cli` is needed day-to-day. If you want a local server: `brew services start redis`.
- **sqlcmd** — nothing to configure; connect with `sqlcmd -S <server> -d <db> -G` (Entra auth) or `-U <user>`.
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
- Guard `.aladd.zsh` completion sourcing on `command -v` so missing tools don't warn
