# Nushell Environment Config File
#
# version = "0.86.0"

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will 
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# System PATH
let path_dirs = [
    # Homebrew paths (critical for macOS)
    "/opt/homebrew/bin"                # M1/M2 Macs
    "/usr/local/bin"                   # Intel Macs
    "/opt/homebrew/sbin"
    "/usr/local/sbin"

    # Personal paths
    $"($env.HOME)/.local/bin"
    $"($env.HOME)/bin"
    $"($env.HOME)/.cargo/bin"                          # Rust
    $"($env.HOME)/.agda"                               # Agda
    $"($env.HOME)/.MATLAB/bin"                         # MATLAB
    $"($env.HOME)/.cabal/bin"                          # Haskell
    $"($env.HOME)/.opam/default/bin"                   # OCaml
    $"($env.HOME)/.opam/forester-5.x/bin"              # OCaml
    $"/usr/local/texlive/2025/bin/universal-darwin"    # Latex

    # Conda paths
    "/opt/anaconda3/bin"
    "/opt/anaconda3/condabin"

    # Julia paths
    $"($env.HOME)/.juliaup/bin"
]

## OCaml/OPAM environment (dynamic)
#let opam_vars = (opam env | lines | each { |line|
#    let cleaned = ($line | str replace " export.*" "")
#    if ($cleaned | str contains "=") {
#        let parts = ($cleaned | split row "=" | take 2)
#        {
#            name: ($parts.0 | str trim)
#            value: ($parts.1 | str trim --char "'" | str trim --char '"')
#        }
#    }
#} | compact)
#
#for var in $opam_vars {
#    match $var.name {
#        "OPAM_LAST_ENV" => { $env.OPAM_LAST_ENV = $var.value }
#        "OPAM_SWITCH_PREFIX" => { $env.OPAM_SWITCH_PREFIX = $var.value }
#        "OCAMLTOP_INCLUDE_PATH" => { $env.OCAMLTOP_INCLUDE_PATH = $var.value }
#        "CAML_LD_LIBRARY_PATH" => { $env.CAML_LD_LIBRARY_PATH = $var.value }
#        "OCAML_TOPLEVEL_PATH" => { $env.OCAML_TOPLEVEL_PATH = $var.value }
#        "PATH" => { 
#            # Extract just the OPAM bin path and prepend it
#            let opam_bin = ($var.value | split row ":" | first)
#            $env.PATH = ($env.PATH | prepend $opam_bin)
#        }
#    }
#}

# Set PATH by prepending our paths to the existing PATH
$env.PATH = ($env.PATH | prepend $path_dirs | uniq)

# Set default editor
$env.EDITOR = "nvim"

# C++ environment
$env.PKG_CONFIG_PATH = if 'PKG_CONFIG_PATH' in $env {
    $env.PKG_CONFIG_PATH + ":/usr/local/lib/pkgconfig/" 
} else {
    "/usr/local/lib/pkgconfig/"
}

$env.LD_LIBRARY_PATH = if 'LD_LIBRARY_PATH' in $env {
    $env.LD_LIBRARY_PATH + ":/usr/local/lib:/opt/wxgtk-dev/lib/"
} else {
    "/usr/local/lib:/opt/wxgtk-dev/lib/"
}

# LaTeX
$env.TEXMFHOME = $"($env.HOME)/Library/texmf"

# ROS
$env.DBUS_SESSION_BUS_ADDRESS = if 'DBUS_LAUNCHD_SESSION_BUS_SOCKET' in $env {
    $"unix:path=($env.DBUS_LAUNCHD_SESSION_BUS_SOCKET)"
} else {
    "unix:path=/tmp/dbus-socket"
}

# Starship prompt initialization
$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship/starship.toml"

# Terminal colors
$env.COLORTERM = "truecolor"

