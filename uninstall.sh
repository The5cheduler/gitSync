#!/bin/bash

# Determine the user's shell profile
if [ -n "$ZSH_VERSION" ]; then
  SHELL_PROFILE="$HOME/.zshrc"
fi

# Check if gitSync is installed
if [ ! -d "$HOME/.gitSync" ]; then
  echo "😅 Oops! It looks like gitSync is not installed. Nothing to uninstall!"
  exit 1
fi

# Remove the cloned repository
echo "🗑️  Uninstalling gitSync..."
rm -rf "$HOME/.gitSync"

# Remove the PATH modification from the user's shell profile
if grep -q 'export PATH="\$HOME/.gitSync:\$PATH"' "$SHELL_PROFILE"; then
  sed -i '/export PATH="\$HOME\/.gitSync:\$PATH"/d' "$SHELL_PROFILE"
  echo "Removed PATH modification from $SHELL_PROFILE"
else
  echo "No PATH modification found in $SHELL_PROFILE"
fi

# Source the shell profile to update the PATH in the current session
source "$SHELL_PROFILE" &> /dev/null

echo "😢 We are sorry to see you go! Syncing your repositories will no longer be as easy as before."
echo "👋 See you soon!"

exit 0
