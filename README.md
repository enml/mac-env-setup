# mac-env-setup
- ## brew
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
- ## iterm2

  - ### oh-my-zsh
     ```
     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
     ```
  - ### space-ship
     ``` 
      git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
      ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
      ```
  - ### plugins
    - #### nvm
       ```
       git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
       ```
    - #### fzf
       ``` 
        brew install fzf
        # To install useful key bindings and fuzzy completion:
        $(brew --prefix)/opt/fzf/install
        ```
    - #### zsh-autosuggestions
       ```
       git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
       ```
    - #### zsh-syntax-highlighting.git 
       ```
       git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
       ```
- ## neovim
  - ### install
    ```
    brew install neovim
    ```
  - ### configure 
    ```
    # clone this repo
    ```
