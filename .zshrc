# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
                git
        )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#


#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function setTarget(){
  target=$1
  echo "$1" > $HOME/.config/bin/target
  source ~/.zshrc
  echo -e "[!] TARGET: $ASSET"
}

function mkt(){
	mkdir {nmap,content,exploits,scripts}
}

# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

function initScan(){
  nmap -p- --min-rate 3000 -v -oG $PWD/init_scan.grep -Pn -sS $1 
}

function cve2url(){
  if [[ ! $1 ]]; then
    echo -e "[!] Uso: $0 <file_with_cve>"
  else
    output_file="$1_URLS.csv"
    sorted_file="$1_sorted.txt"
    sort -u -r $1 > $sorted_file
    echo 'cve_id,cve_url' > $output_file

    cat $1 | while read cve;do    
      url_to_cvepage="https://www.cvedetails.com/cve"
      full_cve_url=$url_to_cvepage/$cve
      echo "$cve,$full_cve_url" | tee -a $output_file 
    done
  fi
}

function domainInspector(){
  if [[ ! $1 ]]; then
    echo -e "[!] Uso: $0 domains.txt"
  fi
  if [[ ! -f /usr/bin/asn ]]; then
    echo -e "[!] No tienes instalado asn. Procediendo..."
    sudo apt install asn
    echo -e "[!] Vuelva a lanzar la función"
    exit 1
  fi

  for domain in $(cat $1); do
    asn -j "$domain" | tee -a inspectedDomains.json
  done
  
}

function asn2obsidian(){
    #!/bin/bash
  file=$1
  if [[ ! $file ]]; then
    echo -e "[!] Uso: $0 <path_to_domains>.txt"
    sleep 2
    exit 1
  fi
  echo "Espere, suele tardar un poco..."

  echo "asset,domain,host_type,ipaddr,dig_output,asn_target,asn_ip,as_number,as_name,org,country,city,cpes,ports" > enriched_assets.csv
  number=1


  for line in $(cat $file) ; do
    echo -e "[$number/$(wc -l $file |awk '{print $1}')]"
      asset_code=$(printf "A%02d" "$number")
      ip=$(dig +short "$line" | head -n 1)
      dig_output=$(dig "$line" | awk '/ANSWER SECTION:/ {flag=1; next} /;;/ {if (flag) exit} flag' | tr '\n' ';' | sed 's/;*$//')

      # Skip if no IP was resolved
      if [[ -z "$ip" ]]; then
          echo "$asset_code,$line,N/A,N/A,N/A,N/A,N/A,N/A,N/A,N/A,N/A" >> enriched_assets.csv
          ((number++))
          continue
      fi

      # Run asn and save JSON temporarily
      tmp_json=$(mktemp)
      asn -j "$ip" > "$tmp_json"

      # Extract fields with jq
      asn_csv=$(jq -r '. as $root | .results[] | [ $root.target, $root.target_type, .ip, .routing.as_number, .routing.as_name, .org_name, .geolocation.country, .geolocation.city , (.fingerprinting.cpes | join (";")) , (.fingerprinting.ports | join (";")) ] | @csv' "$tmp_json")

      # Combine all fields and write final output
      echo "$asset_code,$line,$ip,\"$dig_output\",$asn_csv" >> enriched_assets.csv

      rm "$tmp_json"
      ((number++))
  done
}


export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export ASSET=$(cat $HOME/.config/bin/target)

alias ocat="/usr/bin/cat"
alias ls="lsd"
alias catrl="batcat"
alias cat="batcat --paging=never"
alias cheatsh="cht.sh"

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
export WINDIR="/mnt/c/Users/Sergio Pozo"

export PATH=$HOME/.local/bin:$PATH

alias ocat="/usr/bin/cat"
alias cdl='eval "cd !$"'

## LS Custom Alias
alias pls="/usr/bin/lsd --human-readable --date relative -l --total-size"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
