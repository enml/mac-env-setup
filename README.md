

# 配置 ssh key to GitHub
gen a ssh key:

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

set key to Github:

https://github.com/settings/keys

拉取该项目到本地


# karabiner

下载 karabiner：https://karabiner-elements.pqrs.org/

替换 karabiner.json 到 `~/.config/karabiner/`

# brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

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
### packer
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# 1. 进入 nvim，执行：PackerSync
 ```
### LSP install
```
# 进入 nvim，执行：LspInstall

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


