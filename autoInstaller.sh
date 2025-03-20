#!/bin/bash
# Colours
declare -g RED="\033[1;31m"
declare -g GREEN="\033[1;32m"
declare -g YELLOW="\033[1;33m"
declare -g BLUE="\033[1;34m"
declare -g PURPLE="\033[1;35m"
declare -g CYAN="\033[1;36m"
declare -g WHITE="\033[1;37m"
declare -g GRAY="\033[1;30m"
declare -g RESET="\033[0m"


# Global Variables
declare -g raw_files_dir="https://raw.githubusercontent.com/S4njer/My-parrot-Configurations/refs/heads/main"

# Functions
function help() {
  echo "Usage: $0 [-h] [-i]"
  echo "Options:"
  echo "  -h  Display help"
  echo "  -i (tmux/nvchad/zsh/all) Install tmux/nvchad/zsh or all"
}

function nvchadInstall() {
  echo -e "$YELLOW[!]$GRAY Installing nvchad...\n"
  wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz 
  echo -e "\n${YELLOW}[!]${GRAY} Extracting nvchad..."
  tar x -f nvim-linux64.tar.gz
  cp -r nvim-linux64/* ~/.local/
  rm -rf nvim-linux64 nvim-linux64.tar.gz 2>/dev/null

  # Install dependencies
  dependencies=("gcc" "zip")
  echo -e "\n\t${YELLOW}[!]${GRAY} Installing dependencies: ${YELLOW}${dependencies[@]}${GRAY} "
  sudo apt install "${dependencies[@]}" -y 2>/dev/null

  if [[ -d "$HOME/.config/nvim" ]]; then
    echo -e "\n\t${YELLOW}[!]${GRAY} nvchad already installed, updating nvchad..."
    rm -rf $HOME/.config/nvim 2>/dev/null
    git clone https://github.com/NvChad/starter ~/.config/nvim
    mv $HOME/.config/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua.bak
    wget "$raw_files_dir/.config/nvim/lua/plugins/init.lua" -O $HOME/.config/nvim/lua/plugins/init.lua
    git clone https://github.com/nvzone/typr.git $HOME/.local/nvim/lazy/typr
    nvim
  else
    echo -e "\n\t${YELLOW}[!]${GRAY} Installing nvchad..."
    git clone https://github.com/NvChad/starter ~/.config/nvim
    mv $HOME/.config/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua.bak
    wget "$raw_files_dir/.config/nvim/lua/plugins/init.lua" -O $HOME/.config/nvim/lua/plugins/init.lua
    git clone https://github.com/nvzone/typr.git $HOME/.local/nvim/lazy/typr
    nvim
  fi
  
  
}

function zshInstall() {
  echo -e "[!] Installing zsh...\n"
  sudo apt-get install zsh -y 2>/dev/null
  echo -e "\n[!] Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh ; exit)"
  echo -e "\n[?] Done"

  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/plugins/zsh-autosuggestions
  mv $HOME/.zshrc $HOME/.zshrc.bak
  wget https://raw.githubusercontent.com/S4njer/My-parrot-Configurations/refs/heads/main/.zshrc -O $HOME/.zshrc

  echo -e -n "[!] Do you want to install lsd and bat? (y/n): " && read -r  lsd_bat_option
  if [[ "$lsd_bat_option" == "y" ]]; then
    echo -e "\n[!] Installing lsd and bat..."
    echo -e -n"\n[!] Do you want on your user (1) or system wide (2)?" && read -r lsd_bat_option
    if [[ "$lsd_bat_option" == "1" ]]; then
      wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
      dpkg-deb -x lsd_1.1.5_amd64.deb lsd_dir
      wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb
      dpkg-deb -x bat_0.25.0_amd64.deb bat_dir
      cp -r lsd_dir/usr/* $HOME/.local/
      cp -r bat_dir/usr/* $HOME/.local/
      rm lsd_1.1.5_amd64.deb bat_0.25.0_amd64.deb
      
      rm -rf lsd_dir bat_dir 2>/dev/null
      source $HOME/.zshrc
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