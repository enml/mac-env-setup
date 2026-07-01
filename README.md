# mac-env-setup

个人 Mac 环境配置备份，换机时用来一键复原。

> **维护约定**：任何新的系统级配置（Karabiner 键位、tmux/zsh/nvim 配置、brew 包、
> 系统偏好、快捷键、输入法等）都记录到本仓库——配置文件直接同步进来（如 `karabiner.json`、
> `.tmux.conf`、`.zshrc`），并在 README 对应小节补一句说明。目标是：新 Mac 上照 README
> 走一遍就能完整复原。

---

# 配置 ssh key to GitHub
gen a ssh key:

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

set key to Github:

https://github.com/settings/keys

拉取该项目到本地


# karabiner

下载 karabiner：https://karabiner-elements.pqrs.org/
（或 `brew install --cask karabiner-elements`）

替换 karabiner.json 到 `~/.config/karabiner/`

启动 karabiner 并给权限（Driver Extension + Input Monitoring）

当前启用的 complex modifications（都在 karabiner.json 里）：
- **Map Ctrl-[ to Esc**
- **Left option + hjkl → 方向键（Vim 风格）**
- **tmux prefix: Ctrl+B 在中文输入法下也生效** —— 按 Ctrl+B 时先切到英文输入源（ABC）再把 Ctrl+B 放行，避免中文输入法吞掉 tmux 前缀键。若英文源不是 ABC，改 `input_source_id`（如 `com.apple.keylayout.US`）。

# brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
按 log 提示添加 PATH

# iterm2
### 1. cp .zshrc to ~

### 2. oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### 3. space-ship
```
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```
### 4. plugins
#### a. nvm
```
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
```
#### b. fzf
```
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
```
#### c. zsh-autosuggestions
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
#### d. zsh-syntax-highlighting.git 
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
### 4. font
```
https://www.nerdfonts.com/font-downloads
# 选择 Fira Mono font
# item2 配置 text 里面选择字体 + 字体大小
```

# neovim
### install
```
brew install neovim
# 1. clone mac-env-setup repo
# 2. cp to ~/.config/nvim/
```

### 安装 nodes
```
nvm install 20.15.0
nvm use 20.15.0
```

### packer
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# 1. 进入 nvim，执行：PackerSync
 ```

### install eslint
```
npm i eslint@8.57.0 -g
 ```
### install ripgrep

https://github.com/BurntSushi/ripgrep#installation

# tmux
#### Install
```
brew install tmux
```
#### Update .tmux.conf
copy .tmux.conf to ~/

#### Tmux Plugin Manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
#### Reload
```
tmux source ~/.tmux.conf
```

# node
### nvm
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

# Raycast
1. install Raycast
2. open the Raycase.xx.rayconfig and import
