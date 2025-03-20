#!/bin/bash

# Functions
function help() {
  echo "Usage: $0 [-h] [-i]"
  echo "Options:"
  echo "  -h  Display help"
  echo "  -i (tmux/nvchad/zsh) Install tmux/nvchad/zsh"
}

function nvchadInstall() {
  echo -e "[!] Installing nvchad...\n"
  wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
  tar xzvf nvim-linux64.tar.gz
  sudo cp -r nvim-linux64/* ~/.local/
  git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
  echo -e "\n[?] Done"
}

function zshInstall() {
  echo -e "[!] Installing zsh...\n"
  sudo apt-get install zsh -y 2>/dev/null
  echo -e "\n[!] Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo -e "\n[?] Done"

  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/plugins/zsh-autosuggestions
  mv $HOME/.zshrc $HOME/.zshrc.bak
  wget https://raw.githubusercontent.com/S4njer/My-parrot-Configurations/refs/heads/main/.zshrc -O $HOME/.zshrc

  echo -e -n "[!] Do you want to install lsd and bat?" && read -r  lsd_bat_option
  if [[ "$lsd_bat_option" == "y" ]]; then
    echo -e "\n[!] Installing lsd and bat..."
    echo -e -n"\n[!] Do you want on your user (1) or system wide (2)?" && read -r lsd_bat_option
    if [[ "$lsd_bat_option" == "1" ]]; then
      wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
      dpkg -i lsd_1.1.5_amd64.deb -x $HOME/.local/bin
      wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb
      dpkg -i bat_0.25.0_amd64.deb -x $HOME/.local/bin
      rm lsd_1.1.5_amd64.deb bat_0.25.0_amd64.deb
    else
      sudo apt-get install lsd bat -y 2>/dev/null
    fi
    echo -e "\n[?] Done"
  fi
  }
function tmuxInstall() {
  echo -e "[!] Installing tmux...\n"
  sudo apt-get install tmux -y 2>/dev/null
  echo -e -n "\n\n[!] What do you want to do, download S4njer's tmux(1) config or gpakosz's tmux config(2)? " && read -r tmux_download_option
  if [[ "$tmux_download_option" == "1" ]]; then
    raw_install_file="https://raw.githubusercontent.com/S4njer/My-parrot-Configurations/refs/heads/main"
  elif [[ "$tmux_download_option" == "2" ]]; then
    raw_install_file="https://raw.githubusercontent.com/gpakosz/.tmux/refs/heads/master"
  else
    echo "Invalid option"
    echo -e "\n[1] S4njer's tmux config\n[2] gpakosz's tmux config"
    exit 1
  fi
  echo -e "\n[!] Downloading tmux config..."
  if [[ -f "$HOME/.tmux.conf" ]] || [[ -f "$HOME/.tmux.conf.local" ]]; then
    rm "$HOME/.tmux.conf" 2>/dev/null
    rm "$HOME/.tmux.conf.local" 2>/dev/null
  fi
  curl -s -X GET "$raw_install_file/.tmux.conf" >"$HOME/.tmux.conf"
  curl -s -X GET "$raw_install_file/.tmux.conf.local" >"$HOME/.tmux.conf.local"

  echo -e "\n[!] Downloading tmux plugins..."

  echo -e "\t Downloading TPM"
  git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm 2>/dev/null

  echo -e "\t Downloading tmux-cpu"
  git clone https://github.com/tmux-plugins/tmux-cpu.git $HOME/.tmux/plugins/tmux-cpu 2>/dev/null

  echo -e "\t Downloading tmux-sidebar"
  git clone https://github.com/tmux-plugins/tmux-sidebar.git $HOME/.tmux/plugins/tmux-sidebar 2>/dev/null

  echo -e "\n[!] TPM CheatSheet: \n\n[Ctrl + b] + I -> Install plugins\n[Ctrl + b] + U -> Update plugins\n[Ctrl + b] + R -> Reload tmux\n[Ctrl + b] + Shift + I -> Install new plugins\n[Ctrl + b] + Shift + U -> Remove plugins\n[Ctrl + b] + Shift + R -> Remove all plugins"
  echo -e "\n[!] Sidebar Cheatsheet: \n\n[Ctrl + b] + b -> Toggle sidebar\n[Ctrl + b] + B -> Toggle sidebar on the left\n[Ctrl + b] + Shift + B -> Toggle sidebar on the right"
  echo -e "\n\n[?] Done"
  tmux source "$HOME/.tmux.conf"
}

function install() {
  if [[ "$selection" == "tmux" ]]; then
    tmuxInstall
  elif [[ "$selection" == "nvchad" ]]; then
    nvchadInstall
  elif [[ "$selection" == "zsh" ]]; then
    zshInstall
  elif [[ "$selection" == "all" ]]; then
    tmuxInstall
    nvchadInstall
    zshInstall
  else
    echo "Invalid option"
    help
  fi
}

# Options
while getopts "hi:" args; do
  case "$args" in
  h)
    help
    exit 1
    ;;
  i)
    selection="$OPTARG"
    install
    ;;
  *)
    echo "Invalid option"
    help
    ;;
  esac
done

if [[ ! $1 ]]; then
  help
fi