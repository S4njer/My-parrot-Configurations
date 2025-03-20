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
  echo -e "\n\t${YELLOW}[!]${GRAY} Installing dependencies: ${YELLOW}gcc & zip${GRAY} "
  sudo apt install gcc zip -y 2>/dev/null

  if [[ -d "$HOME/.config/nvim" ]]; then
    echo -e "\n\t${YELLOW}[!]${GRAY} nvchad already installed, updating nvchad..."
    rm -rf $HOME/.config/nvim 2>/dev/null
    git clone https://github.com/NvChad/starter ~/.config/nvim
    mv $HOME/.config/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua.bak
    wget "$raw_files_dir/init.lua" -O $HOME/.config/nvim/lua/plugins/init.lua
    git clone https://github.com/nvzone/typr.git $HOME/.local/nvim/lazy/typr
    nvim
  else
    echo -e "\n\t${YELLOW}[!]${GRAY} Installing nvchad..."
    git clone https://github.com/NvChad/starter ~/.config/nvim
    mv $HOME/.config/nvim/lua/plugins/init.lua $HOME/.config/nvim/lua/plugins/init.lua.bak
    wget "$raw_files_dir/init.lua" -O $HOME/.config/nvim/lua/plugins/init.lua
    git clone https://github.com/nvzone/typr.git $HOME/.local/nvim/lazy/typr
  fi

  
}

function zshInstall() {
  echo -e "$YELLOW[!]$RESET Installing zsh...\n"
  sudo apt-get install zsh -y 2>/dev/null
  echo -e "\n\t$YELLOW[!]$RESET Installing oh-my-zsh..."
  sh -c "$(curl -fsSL $raw_files_dir/oh_my_zsh_install.sh)"
  echo -e "\n[?] Done"

  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/plugins/zsh-autosuggestions
  mv $HOME/.zshrc $HOME/.zshrc.bak
  wget https://raw.githubusercontent.com/S4njer/My-parrot-Configurations/refs/heads/main/.zshrc -O $HOME/.zshrc

  echo -e -n "${YELLOW}[!]${RESET} Do you want to install lsd and bat? ${YELLOW}(y/n)${RESET}: " && read -r  lsd_bat_option
  if [[ "$lsd_bat_option" == "y" ]]; then
    echo -e "\n${YELLOW}[!] Installing lsd and bat...${RESET}"
    echo -e -n"\n${YELLOW}[!]${RESET} Do you want on your user ${YELLOW}(1)${RESET} or system wide ${YELLOW}(2)${RESET}?" && read -r lsd_bat_option
    if [[ "$lsd_bat_option" == "1" ]]; then
      declare -g installation_type="user"
      wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
      dpkg-deb -x lsd_1.1.5_amd64.deb lsd_dir
      wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb
      dpkg-deb -x bat_0.25.0_amd64.deb bat_dir
      cp -r lsd_dir/usr/* $HOME/.local/
      cp -r bat_dir/usr/* $HOME/.local/
      rm lsd_1.1.5_amd64.deb bat_0.25.0_amd64.deb
      
      rm -rf lsd_dir bat_dir 2>/dev/null
      git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
      
      # Add aliases
      echo -e -n 'alias ls="lsd"' | tee -a $HOME/.zshrc
      echo -e -n 'alias catrl="bat"' | tee -a $HOME/.zshrc
      echo -e -n 'alias cat="bat --paging=never"' | tee -a $HOME/.zshrc
      echo -e -n 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' | tee -a $HOME/.zshrc

      source $HOME/.zshrc 2>/dev/null
    elif [[ "$lsd_bat_option" == "2" ]]; then
      declare -g installation_type="system wide"

      # Install lsd and bat
      echo -e "\n${YELLOW}[!] Making system wide installation...${RESET}"
      sudo apt update -y 2>/dev/null
      sudo apt-get install lsd bat zsh-autosuggestions zsh-syntax-highlighting -y 2>/dev/null
      sudo mv /etc/zsh/zshrc /etc/zsh/zshrc.bak
      sudo wget "$raw_files_dir/.zshrc" -O /etc/zsh/zshrc

      # Add aliases
      echo -e 'alias ls="/usr/bin/lsd"' | sudo tee -a /etc/zsh/zshrc
      echo -e 'alias catrl="/usr/bin/batcat"' | sudo tee -a /etc/zsh/zshrc
      echo -e 'alias cat="/usr/bin/batcat --paging=never"' | sudo tee -a /etc/zsh/zshrc
      echo -e 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' | sudo tee -a /etc/zsh/zshrc
      echo -e 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' | sudo tee -a /etc/zsh/zshrc

      source /etc/zsh/zshrc 2>/dev/null

    else
    echo "${RED}Invalid option${RESET}, 1 = user installation, 2 = system installation" && exit 1
      
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
  tmuxInstall_final_message="$YELLOW[!]$RESET Tmux installed, launch it with the command: ${YELLOW}tmux$RESET"
  nvchadInstall_final_message="$YELLOW[!]$RESET Nvchad installed, launch it with the command: ${YELLOW}nvim$RESET"
  zshInstall_final_message="$YELLOW[!]$RESET Zsh installed, restart your terminal with the command: ${YELLOW}source ~/.zshrc$RESET"

  if [[ "$selection" == "tmux" ]]; then
    tmuxInstall
    echo -e "$tmuxInstall_final_message"
  elif [[ "$selection" == "nvchad" ]]; then
    nvchadInstall
    echo -e "$nvchadInstall_final_message"
  elif [[ "$selection" == "zsh" ]]; then
    zshInstall
    echo -e "$zshInstall_final_message"
  elif [[ "$selection" == "all" ]]; then
    tmuxInstall
    zshInstall
    nvchadInstall

    echo -e "\n${PURPLE}Final messages:${RESET}"
    echo -e "\t$tmuxInstall_final_message"
    echo -e "$PURPLE[+]$RESET First you need to initialize your zsh shell:\n\t$zshInstall_final_message"
    echo -e "$PURPLE[+]$RESET Then you can launch nvchad with the command: \n\t$nvchadInstall_final_message"
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