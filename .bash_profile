# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

# Load custom keyboard layout
doas loadkeys .config/loadkeys/loadkeysrc

# Set environment variables
export BROWSER="firefox"
export TERMINAL="st"
export TERM="st"
export PATH=$HOME/.local/bin/:$PATH

# Start X session if not already running
[[ ! $DISPLAY && $(tty) = "/dev/tty1" ]] && startx
