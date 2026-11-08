#!/bin/bash
# 一键配置 Apple Silicon Mac 开发环境。可重复执行：已装好的步骤会跳过。
# 用法：先装好 Homebrew（见 README），然后在 repo 根目录执行 ./install.sh
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
NODE_VERSION=20.15.0
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# 已存在且内容不同的文件先备份再覆盖
install_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && ! cmp -s "$src" "$dst"; then
    cp "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
  fi
  cp "$src" "$dst"
}

clone() { [ -d "$2" ] || git clone -q --depth=1 "$1" "$2"; }

# ---------------------------------------------------------------- Homebrew
step "Homebrew"
if [ ! -x /opt/homebrew/bin/brew ]; then
  echo "未找到 Homebrew，请先按 README 安装 Homebrew 再运行本脚本。" >&2
  exit 1
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
# Karabiner 的安装包需要 sudo，这里会提示输入密码
brew bundle --file="$REPO/Brewfile" || echo "!! brew bundle 有失败项，见上方输出（常见：karabiner-elements 需要密码）"

# ---------------------------------------------------------------- zsh
step "oh-my-zsh + 主题 + 插件"
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
clone https://github.com/lukechilds/zsh-nvm "$ZSH_CUSTOM/plugins/zsh-nvm"
clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

install_file "$REPO/.zshrc" "$HOME/.zshrc"
install_file "$REPO/.zprofile" "$HOME/.zprofile"
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish >/dev/null

# ---------------------------------------------------------------- Node
step "nvm + Node $NODE_VERSION + 全局 npm 包"
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh)"
fi
set +u; . "$NVM_DIR/nvm.sh"
nvm install "$NODE_VERSION" >/dev/null
nvm alias default "$NODE_VERSION" >/dev/null
nvm use "$NODE_VERSION" >/dev/null; set -u
npm i -g eslint@8.57.0 prettier >/dev/null

# ---------------------------------------------------------------- tmux
step "tmux + tpm 插件"
install_file "$REPO/.tmux.conf" "$HOME/.tmux.conf"
clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null

# ---------------------------------------------------------------- Ghostty / Karabiner
step "Ghostty / Karabiner 配置"
install_file "$REPO/ghostty/config" "$HOME/.config/ghostty/config"
install_file "$REPO/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# ---------------------------------------------------------------- macOS 设置
step "macOS 设置"
# Caps Lock 由 Karabiner 接管（轻按 = Ctrl+Space 切换输入法，按住 = Control），
# 关掉系统自带的「Caps Lock 切换 ABC」，避免冲突
defaults write com.apple.HIToolbox TISRomanSwitchState -int 0

# ---------------------------------------------------------------- Neovim
step "Neovim 配置 + 插件 + LSP"
mkdir -p "$HOME/.config/nvim"
rsync -a --exclude .nvimlog --exclude plugin/packer_compiled.lua "$REPO/nvim/" "$HOME/.config/nvim/"
clone https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
# 首次同步时 colorscheme/treesitter 还没下载会报错，属于正常现象
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' >/dev/null 2>&1 || true
nvim --headless -c 'MasonInstall lua-language-server typescript-language-server markdown-oxide yaml-language-server biome' -c 'qa' >/dev/null 2>&1 || true

# ---------------------------------------------------------------- 完成
step "完成。还需要手动做的："
cat <<'EOF'
  1. 打开 Karabiner-Elements，按提示在系统设置里授权
  2. 打开 Raycast，导入 repo 里的 .rayconfig
  3. Safari → 设置 → 搜索 → 搜索引擎选 Google（系统沙盒，脚本改不了）
  4. 生成 SSH key 并添加到 https://github.com/settings/keys
  5. 关掉终端，打开 Ghostty
EOF
