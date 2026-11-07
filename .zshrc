# zsh config — Apple Silicon Mac. Installed by install.sh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Homebrew (Apple Silicon)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.local/bin:$PATH"

# --- clash verge rev proxy (copied from ~/.bashrc) ---
PROXY_PORT=7897   # 与 Clash Verge Rev「设置 → 端口设置 → 混合端口」一致
_NO_PROXY="localhost,127.0.0.1,::1,*.local,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
proxy_on() {
  export http_proxy="http://127.0.0.1:$PROXY_PORT"
  export https_proxy="$http_proxy"
  export all_proxy="socks5://127.0.0.1:$PROXY_PORT"
  export HTTP_PROXY="$http_proxy" HTTPS_PROXY="$https_proxy" ALL_PROXY="$all_proxy"
  export no_proxy="$_NO_PROXY" NO_PROXY="$_NO_PROXY"
}
proxy_off() {
  unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY no_proxy NO_PROXY
  echo "proxy off"
}
# 只有 Clash 在运行（端口开着）时才自动开代理，否则直连
nc -z -G 1 127.0.0.1 $PROXY_PORT 2>/dev/null && proxy_on

ZSH_THEME="spaceship"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
  zsh-nvm
)

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8

alias cdcode="cd ~/Documents/Code"
alias vi=nvim

set -o vi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    # nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

DEFAULT_USER=$(whoami)

# Spaceship prompt is loaded via ZSH_THEME above

# fix fork-ts-checker-webpack-plugin CPU bug
export TSC_WATCHFILE=UseFsEvent

# fix git 中文问题
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
