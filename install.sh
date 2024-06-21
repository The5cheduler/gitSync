#!/bin/bash

# Spinner
spinner() {
  local pid=$1
  local delay=0.75
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Error: git is not installed. Please install git and try again."
  exit 1
fi

# Clone the Git repository to the user's home directory
echo "Installing gitSync..."
git clone https://github.com/yourusername/gitSync.git $HOME/.gitSync &
spinner $!

# Add the directory to the PATH in the user's shell profile
echo 'export PATH="$HOME/.gitSync:$PATH"' >> $HOME/.bashrc

# Source the shell profile to update the PATH in the current session
source $HOME/.zshrc

echo "gitSync 🔧  has been installed successfully."
