#!/bin/bash

# Spinner
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  tput civis # Hide cursor
  echo -n " "
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    for i in $(seq 0 3); do
      printf "\b${spinstr:$i:1}"
      sleep $delay
    done
  done
  printf "\b"
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
source $HOME/.zshrc

echo "gitSync 🔧  has been installed successfully."
