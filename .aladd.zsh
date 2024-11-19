# default zsh auto completion
autoload -Uz compinit
compinit

# history settings
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# common tool replacements with better versions
alias cat='bat'
alias ls='eza -a -1 --icons=never --long --no-permissions --no-user --group-directories-first --changed --time-style=+"%m-%d-%y %I:%M%p"'
alias grep='rg'
alias find='fd'
alias cd='z'
alias vim='nvim'
alias v='nvim'
alias gitui='lazygit --use-config-file="$HOME/Library/Application Support/lazygit/config.yml,$HOME/.config/lazygit/catppuccin-mocha-blue.yml"'

# check ports in us
alias portcheck='lsof -i -n -P'

# redirect eza config dir, and unset env vars that override config
export EZA_CONFIG_DIR="$HOME/.config/eza"
unset EZA_COLORS
unset LS_COLORS

# yazi shell wrapper, changes cwd on exit with 'q', if not wanted then use 'Q'
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# fzf
source <(fzf --zsh)

# setup fzf preview
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# fzf previews
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# use fd for fzf path gen, and ignore certain folders
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# use fd for fzf dir completion, and ignore certain folders
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# use fd or eza for some fzf commands
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# fzf catppuccin theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# dots syncing
syncdots() {
  # Array of files and directories to sync
  local items=(
    ".aladd.zsh"
    ".config/bat/"
    ".config/eza/"
    ".config/karabiner/karabiner.json"
    ".config/lazygit/"
    ".config/nvim/"
    ".config/yazi/"
    ".config/btop/"
    ".config/starship.toml"
  )

  # Check the argument
  if [[ $1 == "push" ]]; then
    for item in "${items[@]}"; do
      local src="$HOME/$item"
      local dest="$HOME/.dotfiles/$item"
      rsync -a "$src" "$dest"
    done
  elif [[ $1 == "pull" ]]; then
    for item in "${items[@]}"; do
      local src="$HOME/.dotfiles/$item"
      local dest="$HOME/$item"
      rsync -a "$src" "$dest"
    done
  else
    echo "Usage: syncdots [push|pull]"
    return 1
  fi
}

# zoxide
eval "$(zoxide init zsh)"
# starship
eval "$(starship init zsh)"
# zsh auto suggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
