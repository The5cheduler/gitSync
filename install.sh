#!/bin/bash

# Advanced Spinner
spinner() {
  local pid=$1
  local delay=0.1
  local frames=(
    "⠋"
    "⠙"
    "⠹"
    "⠸"
    "⠼"
    "⠴"
    "⠦"
    "⠧"
    "⠇"
    "⠏"
  )
  tput civis # Hide cursor
  local frame_index=0
  while kill -0 $pid 2>/dev/null; do
    printf "\r${frames[frame_index]}"
    frame_index=$(( (frame_index + 1) % ${#frames[@]} ))
    sleep $delay
  done
  printf "\r"
  tput cnorm # Show cursor
}

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Error: git is not installed. Please install git and try again."
  exit 1
fi

# Clone the Git repository to the user's home directory
echo "Installing gitSync..."
git clone https://github.com/The5cheduler/gitSync.git $HOME/.gitSync &
spinner $!

# Add the directory to the PATH in the user's shell profile
echo 'export PATH="$HOME/.gitSync:$PATH"' >> $HOME/.bashrc

# Source the shell profile to update the PATH in the current session
source $HOME/.bashrc

echo "gitSync 🔧  has been installed successfully."
