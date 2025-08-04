function install_r_pi_os(){

    VERSION_CODENAME=bookworm
    curl -O  https://pkgs.r4pi.org/dl/${VERSION_CODENAME}/r4pi-repo-conf_0.0.1-1_all.deb
    sudo dpkg -i  r4pi-repo-conf_0.0.1-1_all.deb
    sudo apt update
}


function install_emoji_fonts(){
    echo_and_execute "sudo apt install fonts-noto-color-emoji"
}


function install_docker_pi_os(){
    my_echo "installing docker"
    sudo apt update
    sudo apt upgrade -y
    curl -sSL https://get.docker.com | sh
    my_echo "Adding $USER to the docker group"
    sudo usermod -aG docker $USER
}


function install_astro(){
    my_echo "Installing astro"
    curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | sh
}


function turn_off_wifi_power_mgmt(){

    sudo iw dev wlan0 set power_save off

    my_echo "wlan power status: $(sudo iw dev wlan0 get power_save)"
}

function echo_script_path(){
    shell_name=$(ps -p $$ -o comm=)
    if [ "$shell_name" == "zsh" ] 
    then
        path="$_"
    elif [ "$shell_name" == "bash" ] 
    then
        path="$script_dir/$(basename "${BASH_SOURCE[0]}")"

    else    
        my_echo "unknown shell: $shell_name. Cannot determine script path"
        return 1
    fi
    echo $path
}
