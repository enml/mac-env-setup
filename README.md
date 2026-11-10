# mac-env-setup

Apple Silicon Mac 开发环境：zsh (oh-my-zsh + spaceship) · Ghostty · tmux · Neovim · Node (nvm) · Karabiner · Raycast · Chrome

## 一键安装

### 1. Homebrew（需要输入密码，会顺带装 Xcode Command Line Tools）

如果在国内且用 Clash 等代理，先在当前终端开代理，否则下载 GitHub 会失败：

```
export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. 拉取本 repo 并执行安装脚本

```
eval "$(/opt/homebrew/bin/brew shellenv)"
mkdir -p ~/Documents/Code && cd ~/Documents/Code
git clone https://github.com/enml/mac-env-setup.git && cd mac-env-setup
./install.sh
```

脚本可以重复执行，已经装好的会跳过；被覆盖的配置文件会先备份成 `*.bak.<时间>`。它会：

- `brew bundle` 安装 [Brewfile](Brewfile) 里的工具、应用和字体（Karabiner 安装时需要密码）
- 安装 oh-my-zsh、spaceship 主题、zsh-nvm / zsh-autosuggestions / zsh-syntax-highlighting 插件，fzf 快捷键
- 放置 `.zshrc`、`.zprofile`、`.tmux.conf`、`ghostty/config`、`karabiner.json`、`nvim/`
- nvm + Node 20.15.0（默认），全局 `eslint@8.57.0`、`prettier`
- tpm 及 tmux 插件
- packer + `PackerSync`，Mason 安装 LSP（lua / ts / markdown / yaml / biome）
- macOS：关闭系统自带的 Caps Lock 切换 ABC（改由 Karabiner 处理，见下方）

### 3. 手动步骤

1. **Karabiner**：打开 Karabiner-Elements，按提示在系统设置里允许驱动扩展和「输入监控」
2. **Raycast**：打开 Raycast，导入 repo 里的 `.rayconfig`
3. **Safari**：设置 → 搜索 → 搜索引擎选 Google（Safari 有沙盒，脚本改不了）
4. **SSH key**：按 [GitHub 文档](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) 生成，添加到 https://github.com/settings/keys
5. 退出当前终端，之后用 **Ghostty**

## 说明

- **代理**：`.zshrc` 里 Clash 端口（7897）开着时自动 `proxy_on`；`proxy_off` 关闭
- **Karabiner 规则**：Caps Lock 轻按 = 切换输入法（Ctrl+Space），按住 = Control；`Ctrl-[` → Esc；左 Ctrl + hjkl → 方向键；外接键盘（旧键盘和 Akko Mu02）交换左 Command / Option；在 Ghostty 里按 tmux prefix（Ctrl+b）会先切到 ABC 英文输入法
- **tmux**：prefix + `s`/`v` 分屏，`h/j/k/l` 切换 pane，`R` 重新加载配置
- **nvim-treesitter** 锁定在 `master` 分支：`main` 分支重写后删掉了 `init.lua` 依赖的 `nvim-treesitter.configs`
