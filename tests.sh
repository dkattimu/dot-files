
get_executing_shell_() {
    [[ -n "$BASH_VERSION" ]] && echo "bash" && return
    [[ -n "$ZSH_VERSION" ]] && echo "zsh" && return
    echo "unknown"
}


function __echo_script_path__(){
    
    shell_name= $(get_executing_shell_) #$(ps -p $$ -o comm=)
    echo "shell_name: $shell_name"
    if [ "$shell_name" == "zsh" ] 
    then
        #path="$0" #recall $0 wrks for zsh when executed; not when sourced
        path="Bobo" # ${(%):-%x}
    elif [ "$shell_name" == "bash" ]
    then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        path="$script_dir/$(basename "${BASH_SOURCE[0]}")"
    
    elif [ "$shell_name" == "sh" ]
    then
        script_dir="$(cd "$(dirname "$0")" && pwd)"
        path="$script_dir/$(basename "$0")"
    else    
        echo "unknown shell: $shell_name. Cannot determine script path"
        return 1
    fi
       echo $path
}


__echo_script_path__