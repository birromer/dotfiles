# config.nu - Main configuration for Nushell

# Use starship prompt
use ~/.cache/starship/init.nu

# Aliases - convert from zsh to nu syntax
alias reset = clear; printf '\e[3J'
alias la = ls -a
alias ll = ls -l
alias lal = ls -la
alias pu = cd  # Simple version - can be expanded with custom command
alias wiki = wiki-tui
alias pomodoro = porsmo pomodoro custom 5400 1200 1200

def open_in_nvim [file] {
    nvim $file
}

# Docker ROS commands
def ros-start [] {
    docker run --rm -it --privileged --net=host --ipc=host --env="DISPLAY" \
        --device=/dev/dri:/dev/dri \
        -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v $"($env.HOME)/.Xauthority:/home/robot/.Xauthority" \
        -e $"XAUTHORITY=/home/robot/.Xauthority" \
        -v $"($env.HOME)/robotics:/home/robot/ros" \
        -v "/tmp/:/tmp" \
        -v $"($env.HOME)/mega/datasets:/home/robot/ros/data" \
        -v $"($env.HOME)/Documents/CoppeliaSim:/home/robot/ros/software/coppelia_sim" \
        -e $"DISPLAY=($env.DISPLAY)" \
        -e "ROS_IP=127.0.0.1" \
        -e "DOCKER_USER_NAME=robot" \
        -e $"DOCKER_USER_ID=(id -u)" \
        -e $"DOCKER_USER_GROUP_NAME=(id -gn)" \
        -e $"DOCKER_USER_GROUP_ID=(id -g)" \
        birromer/ros-noetic-intervals:latest
}

def ros-connect [] {
    docker exec -ti (docker ps -aq --filter ancestor=birromer/ros-noetic-intervals:latest --filter status=running | str trim) zsh
}

def ros-clean [] {
    docker rm (docker ps -aq --filter ancestor=birromer/ros-noetic-intervals:latest --filter status=exited | str trim)
}

# History configuration
$env.config = {
    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: "plaintext"
    }
    
    # Key bindings similar to your zsh setup
    keybindings: [
        {
            name: beginning_of_line
            modifier: control
            keycode: char_a
            mode: [emacs, vi_insert]
            event: { send: home }
        }
        {
            name: end_of_line
            modifier: control
            keycode: char_e
            mode: [emacs, vi_insert]
            event: { send: end }
        }
        {
            name: move_word_forward
            modifier: control
            keycode: char_f
            mode: [emacs, vi_insert]
            event: { send: right_word }
        }
        {
            name: move_word_backward
            modifier: control
            keycode: char_b
            mode: [emacs, vi_insert]
            event: { send: left_word }
        }
    ]
    
    # Color customization
    color_config: {
        # Customize ls colors
        ls: {
            dir: {fg: "blue", bold: true}
            file: {fg: "white"}
            symlink: {fg: "cyan", italic: true}
            # Add more ls color customizations as needed
        }
    }
}

# Initialize conda if needed
def --env conda-init [] {
    if not (which conda | is-empty) {
        conda shell.nu hook | save ~/.cache/conda.nu
        source ~/.cache/conda.nu
    }
}

# Load conda environment if the file exists
if ($nu.home-path | path join '.cache' 'conda.nu' | path exists) {
    source ($nu.home-path | path join '.cache' 'conda.nu')
}

# Initialize fzf if installed
if (which fzf | is-empty) == false {
    use ~/.config/nushell/scripts/fzf.nu
}

# Recommended - set up proper completions for nushell
register ~/.cargo/bin/nu_plugin_query
