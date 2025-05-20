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
alias ls='eza -1 --icons=never --long --no-permissions --no-user --group-directories-first  --time-style=+"%m-%d-%y %I:%M%p"'
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

# interactive git branch switching with fzf
gitswitch() {
  # check if inside a git repo
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Not a git repository"
    return 1
  fi

  # find branches via fzf
  local branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | fzf)

  if [[ -z "$branch" ]]; then
    echo "No branch selected"
    return 1
  fi

  # check for remote branch
  if [[ "$branch" == remotes/* ]]; then
    branch=${branch#remotes/}
  fi

  # if remote, extract then pull and track, otherwise just switch to the local branch
  if [[ "$branch" == */* ]]; then
    local remote_name=${branch%%/*}
    local branch_name=${branch#*/}
    git switch --track "$remote_name/$branch_name"
  else
    git switch "$branch"
  fi
}

# interactive branch deleting with fzf
gitbranchd() {
  git branch -D $(git branch | fzf)
}

# alias k8s tools, assumes these are installed
alias k='kubectl'
alias kc='kubectx'
alias kn='kubens'
alias mk='minikube'

# edit k8s stuff with nvim
export KUBE_EDITOR='nvim'

# sh into a k8s container, arg 1 is pod, arg 2 is container in pod
kconnsh() {
  kubectl exec --stdin --tty "$1" -c "$2" -- sh;
}

# restart k8s deployment
krestart() {
  kubectl rollout restart deployments/$1
}

# restart all k8s deployments that start with the naming convention
krestartall() {
  kubectl get deployments --no-headers=true | awk '/{$1}/{print $1}' | xargs -l {} kubectl rollout restart deployments/{}
}

# exec into k8s redis cli
kredis() {
  kubectl exec -it $1 -- redis-cli;
}

# k8s autocompletion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# sh into a container in k8s minikube
mkconnsh() {
  minikube kubectl exec --stdin --tty "$1" -c "$2" -- sh;
}

# reads better
reload() {
  source ~/.zshrc
}

# i'm lazy
gitacp() {
  git add .
  git commit -m "$1"
  git push
}

# lowercase uuidgen
uuidgenl() {
  uuidgen | tr "[A-Z]" "[a-z]"
}

# docker-compose alias
dc() {
  docker compose $@
}

# dots syncing
syncdots() {
  # Array of files and directories to sync
  local items=(
    ".aladd.zsh"
    ".tmux.conf"
    ".config/tmux/tmux.conf"
    ".config/bat/"
    ".config/eza/"
    ".config/karabiner/karabiner.json"
    ".config/lazygit/"
    ".config/nvim/"
    ".config/yazi/"
    ".config/btop/"
    ".config/ghostty/"
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
