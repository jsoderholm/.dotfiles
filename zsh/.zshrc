eval "$(/opt/homebrew/bin/brew shellenv)"

# Set the directory where we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::ssh-agent
zinit snippet OMZP::command-not-found

# Completion definitions
zinit light zsh-users/zsh-completions

# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always "$realpath"'

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Add in zsh plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# Keybindings
bindkey -e
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# Aliases
alias vim="nvim"
alias ls="ls --color"
alias c="clear"
alias o="open ."
alias ls="eza --color=always --group-directories-first"
alias lt="eza --tree --level=2 --color=always --group-directories-first"
alias ll="eza -la --octal-permissions --group-directories-first"
alias l="ls"

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init zsh --cmd cd)"
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"
fi
