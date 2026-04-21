# ~/.zshrc — managed via ~/dotfiles (GNU stow), no Oh My Zsh

# ---------- Homebrew (arm64 + Intel portable) ----------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ---------- PATH ----------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/python@3.12/libexec/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ---------- Environment ----------
export LANG=en_US.UTF-8
export EDITOR="$(command -v nvim)"
export GPG_TTY=$(tty)

# ---------- History ----------
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY

# ---------- Completion ----------
FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -Uz bashcompinit && bashcompinit

command -v kubectl        >/dev/null 2>&1 && source <(kubectl completion zsh)
command -v aws_completer  >/dev/null 2>&1 && complete -C "$(command -v aws_completer)" aws
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ---------- Prompt (starship) ----------
setopt prompt_subst
export STARSHIP_CONFIG=$HOME/.config/starship.toml
eval "$(starship init zsh)"

# ---------- Vi mode ----------
bindkey jj vi-cmd-mode

# ---------- Shell integrations ----------
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(direnv hook zsh)"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ---------- Aliases ----------
alias cl='clear'
alias la=tree
alias cat=bat
alias http=xh
alias nm="nmap -sC -sV -oN nmap"

# eza
alias ls="eza --icons"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb="git branch"
alias gba="git branch -a"
alias gadd="git add"
alias ga="git add -p"
alias gcoall="git checkout -- ."
alias gr="git remote"
alias gre="git reset"

# docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# ranger (cd to last dir on quit)
ranger() {
  local IFS=$'\t\n'
  local tempfile; tempfile="$(mktemp -t tmp.XXXXXX)"
  command ranger --cmd="map Q chain shell echo %d > \"$tempfile\"; quitall" "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$PWD" ]]; then
    cd -- "$(cat "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}
alias rr='ranger'

# navigation
cx()  { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f()   { find . -type f -not -path '*/.*' | fzf | pbcopy; }
fv()  { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# ---------- Plugins (syntax-highlighting MUST be last) ----------
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
