# karabiner
替换 karabiner.json 到 ~/.config/karabiner/

# iterm2
### 1. oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### 2. space-ship
```
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```
### 3. plugins
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
# brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
# tmux
#### Install
```
brew install tmux
```
#### Update .tmux.conf
#### Tmux Plugin Manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
#### Reload
```
tmux source ~/.tmux.conf
```
