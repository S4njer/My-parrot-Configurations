# My-parrot-Configurations
This is a simple bash script that automates my configurations for the desired machine, installing the next:
1. ZSH (With oh-my-zsh configuration files)
    1.1 zsh-syntax-highlightning
    1.2 zsh-autosuggestions
2. TMUX (With the desired configuration, oh-my-tmux by default or s4njer configuration)
3. NvChad (Neovim with a lot of steroids, I've installed one adittional plugin called *typr*)

>[!INFO]
>With this script you can install everything at once or just one of them, just execute the script with the desired option.

## Requirements
- git
- zsh
- tmux
- neovim

## How to use
To use this script you need to execute it with the desired option, the options are:
- `tmux` (To install tmux)
- `nvchad` (To install nvchad)
- `zsh` (To install zsh)
- `all` (To install all the above)

>[!TIP]
> You can change the theme of the ZSH changing it in the specified file:
> - /etc/zsh/zshrc (*If you installed on system wide*)
> - $HOME/.zshrc (*If you installed on user wide*)

# Installation
To install everything into the script you need to execute the script with the `-i` option and the `all` parameter:
```bash
chmod +x autoInstaller.sh
./autoInstaller.sh -h

Usage: ./autoInstaller.sh [-h] [-i]
Options:
  -h  Display help
  -i (tmux/nvchad/zsh/all) Install tmux/nvchad/zsh or all
```

## How to install tmux
To install tmux you don't need to do anything, simply execute `./autoInstaller.sh -i tmux`

>[!NOTE]
>You must change `$SHELL` variable to your desired one `export SHELL="/usr/bin/zsh"` (This is the default shell selected on zshrc)
