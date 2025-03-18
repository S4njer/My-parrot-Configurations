#!/bin/bash

# Functions
function help() {
    echo "Usage: $0 [-h] [-i]"
    echo "Options:"
    echo "  -h  Display help"
    echo "  -i (tmux/nvchad/zsh) Install tmux/nvchad/zsh"
}

function tmuxInstall() {
    echo "Installing tmux..."
    sudo apt-get install tmux
    echo -e -n "[!] What do you want to do, download S4njer's tmux(1) config or gpakosz's tmux config(2)?" && read -r tmux_download_option
    if [[ "$tmux_download_option" == "1" ]]; then
        raw_install_file="https://github.com/S4njer/My-parrot-Configurations/raw/refs/heads/main"
    elif [[ "$tmux_download_option" == "2" ]]; then
        raw_install_file="https://github.com/gpakosz/.tmux/raw/refs/heads/master"
    else
        echo "Invalid option"
        echo -e "\n[1] S4njer's tmux config\n[2] gpakosz's tmux config"
        exit 1
    fi
    echo -e "\n[!] Downloading tmux config..."
    wget "$raw_install_file/.tmux.conf"
    wget "$raw_install_file/.tmux.conf"
    echo -e "\n[!] Downloading tmux plugins..."
    git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tmux-cpu.git $HOME/.tmux/plugins/tmux-cpu
    git clone https://github.com/tmux-plugins/tmux-sidebar.git $HOME/.tmux/plugins/tmux-sidebar

    echo -e "[!] TPM CheatSheet: \n\n[Ctrl + b] + I -> Install plugins\n[Ctrl + b] + U -> Update plugins\n[Ctrl + b] + R -> Reload tmux\n[Ctrl + b] + Shift + I -> Install new plugins\n[Ctrl + b] + Shift + U -> Remove plugins\n[Ctrl + b] + Shift + R -> Remove all plugins"
    echo -e "[!] Sidebar Cheatsheet: \n\n[Ctrl + b] + b -> Toggle sidebar\n[Ctrl + b] + B -> Toggle sidebar on the left\n[Ctrl + b] + Shift + B -> Toggle sidebar on the right"
    echo "Done"
}


function install() {
    echo "Installing..."
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
while getopts in "hi:" args; do
case "$args" in
    h) help; exit 1;;
    i) selection="$OPTARGS" ; echo "Installing";;
    *) echo "Invalid option"; helpPanel;;
esac
done