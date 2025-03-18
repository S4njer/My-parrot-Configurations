#!/bin/bash

# Functions
function help() {
  echo "Usage: $0 [-h] [-i]"
  echo "Options:"
  echo "  -h  Display help"
  echo "  -i (tmux/nvchad/zsh) Install tmux/nvchad/zsh"
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