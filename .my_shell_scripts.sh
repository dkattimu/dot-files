#-**!/bin/bash
#***!/usr/bin/zsh
#!/usr/bin/sh

function my_echo(){
    echo "[⏰$(date) ]  '$1' 🚀"
}


function my_echo_plain(){
    echo "$1 @:$(date)"
}


function echo_and_execute(){
    my_echo "Executing: $1"
    $1
}

function get_executing_shell(){
    $(ps -p $$ -o comm=)
}

 
function echo_script_path(){
    shell_name=$(ps -p $$ -o comm=)
    if [ "$shell_name" == "zsh" ] 
    then
        path="$_"
    else    
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        path="$script_dir/$(basename "${BASH_SOURCE[0]}")"
   fi
    echo $path
}


function install_r_pi_os(){

    VERSION_CODENAME=bookworm
    curl -O  https://pkgs.r4pi.org/dl/${VERSION_CODENAME}/r4pi-repo-conf_0.0.1-1_all.deb
    sudo dpkg -i  r4pi-repo-conf_0.0.1-1_all.deb
    sudo apt update
}


function install_rust(){
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    #echo_and_execute $cmd
    #$cmd
}


function install_lsd(){
    cargo install lsd
    my_echo "setting up .bashrc"
    echo "alias ls=lsd" >> ~/.bashrc
}


function install_emoji_fonts(){
    echo_and_execute "sudo apt install fonts-noto-color-emoji"
}


function install_oh_my_posh(){
    my_echo "about to install oh-my-posh"
    curl -s https://ohmyposh.dev/install.sh | bash -s
}


function install_font_omp(){
    if [ -z "$1" ] 
    then
        my_echo_plain "no args provided. Will install hack font"
        oh-my-posh font install hack

    else 
        my_echo_plain "$1 is provided as an argument.. going ahead to install..."
        oh-my-posh font install $1
    fi
}


function set_posh_theme(){
    posh_theme="gruvbox.omp.json" #"ubblesextra.omp.json"
    if [ -z "$1" ] 
    then
        my_echo_plain "no args provided. will change theme to $posh_theme"
 
    else
        posh_theme="$1"
        my_echo_plain "$1 is provided as argument; will change theme to $posh_theme"
    fi
    exec_shell=$(ps -p $$ -o comm=) #$(oh-my-posh get shell)

    my_echo "executing ..(oh-my-posh --init --shell "$exec_shell" --config "~/posh_themes/$posh_theme")"
    eval "$(oh-my-posh --init --shell "$exec_shell" --config "~/posh_themes/$posh_theme")"
}


function install_uv(){
    my_echo "Attempt to install uv on linux os"
    curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | sh
}


function install_docker_pi_os(){
    my_echo "installing docker"
    sudo apt update
    sudo apt upgrade -y
    curl -sSL https://get.docker.com | sh
    my_echo "Adding $USER to the docker group"
    sudo usermod -aG docker $USER
}


function install_k8s(){
  my_echo "Not yet implemented"
}


function turn_off_wifi_power_mgmt(){

    sudo iw dev wlan0 set power_save off

    my_echo "wlan power status: $(sudo iw dev wlan0 get power_save)"
}


function git_acp(){
    git add .
    git commit -m $1
    git push
}

function make_file_executable(){    
    chmod u+x $1
}
my_echo "sourced $(echo_script_path)"