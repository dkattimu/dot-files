
# Idea above is to call as executable for zsh and source for bash; this enables use of $0 for file name under zsh (as well) 

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

function __get_executing_shell__(){
    $(ps -p $$ -o comm=)
}

get_executing_shell() {
    [[ -n "$BASH_VERSION" ]] && echo "bash" && return
    [[ -n "$ZSH_VERSION" ]] && echo "zsh" && return
    echo "unknown"
}
 
function echo_script_path(){
    #blocking this function for now
    #return 1    
    shell_name= $(get_executing_shell) #$(ps -p $$ -o comm=)
    my_echo "shell_name: $shell_name"
    if [ "$shell_name" == "zsh" ] 
    then
        #path="$0" #recall $0 wrks for zsh when executed; not when sourced
        path=${(%):-%x}
    elif [ "$shell_name" == "bash" ]
    then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        path="$script_dir/$(basename "${BASH_SOURCE[0]}")"
    
    elif [ "$shell_name" == "sh" ]
    then
        script_dir="$(cd "$(dirname "$0")" && pwd)"
        path="$script_dir/$(basename "$0")"
    else    
        my_echo "unknown shell: $shell_name. Cannot determine script path"
        return 1
    fi
       echo $path
}


function install_oh_my_posh(){
    my_echo "about to install oh-my-posh"
    curl -s https://ohmyposh.dev/install.sh | bash -s
}

function install_oh_my_posh_sudo(){
    my_echo "about to install oh-my-posh using sudo"
        my_echo "about to install oh-my-posh"
    mkdir -p ~/.local/bin
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

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
    posh_theme="smoothie.omp.json" #"bubblesextra.omp.json"
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


function run_docker_n8n(){
    my_echo "Running n8n in docker"
    docker volume create n8n_data

    docker run -it --rm \
    --name n8n \
    -p 5678:5678 \
    -e GENERIC_TIMEZONE="America/New_York" \
    -e TZ="America/New_York" \
    -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
    -e N8N_RUNNERS_ENABLED=true \
    -v n8n_data:/home/node/.n8n \
    docker.n8n.io/n8nio/n8n
}

function git_acp(){
    git add .
    git commit -m $1
    git push
}
