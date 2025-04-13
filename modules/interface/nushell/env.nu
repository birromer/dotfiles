# env.nu - Environment configuration for Nushell

# Homebrew paths (critical for macOS)
$env.PATH = ($env.PATH | prepend [
    "/opt/homebrew/bin"                # M1/M2 Macs
    "/usr/local/bin"                   # Intel Macs
    "/opt/homebrew/sbin"
    "/usr/local/sbin"
])

# Add your personal paths from zshrc
$env.PATH = ($env.PATH | prepend [
    $"($env.HOME)/.local/bin"
    $"($env.HOME)/bin"
    $"($env.HOME)/.cargo/bin"         # Rust
    $"($env.HOME)/.agda"              # Agda
    $"($env.HOME)/.MATLAB/bin"        # MATLAB
    $"($env.HOME)/.cabal/bin"         # Haskell
    $"($env.HOME)/.opam/default/bin"  # OCaml
])

# Adding conda paths
$env.PATH = ($env.PATH | prepend [
    "/opt/anaconda3/bin"
    "/opt/anaconda3/condabin"
])

# Adding Julia paths
$env.PATH = ($env.PATH | prepend [
    $"($env.HOME)/.juliaup/bin"
])

# Set default editor
$env.EDITOR = "nvim"

# C++ environment
$env.PKG_CONFIG_PATH = ($env.PKG_CONFIG_PATH | default "" | append ":/usr/local/lib/pkgconfig/")
$env.LD_LIBRARY_PATH = ($env.LD_LIBRARY_PATH | default "" | append ":/usr/local/lib:/opt/wxgtk-dev/lib/")

# LaTeX
$env.TEXMFHOME = $"($env.HOME)/Library/texmf"

# Starship prompt initialization
$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship/starship.toml"

# Terminal colors
$env.COLORTERM = "truecolor"
