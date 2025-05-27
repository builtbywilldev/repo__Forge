#!/bin/bash

# ================================================
# 🔨 RepoForge — install.sh
# Prepares user identity and sets up the forge alias.
# ================================================

CONFIG_DIR="$HOME/.repoforge"
AUTHOR_FILE="$CONFIG_DIR/.author"
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"  # Gets current script's absolute path
LICENSE_SRC="$INSTALL_DIR/dev__Starters/licenses"
LICENSE_DEST="$CONFIG_DIR/licenses"

# Prompt for legal name
read -p "🪪 What is your legal name for license attribution? " AUTHOR_NAME

# Confirm
echo -e "🧾 Your name will appear on all generated LICENSE files: \e[1m$AUTHOR_NAME\e[0m"
read -p "Is this correct? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
  echo "❌ Aborting setup. Rerun ./install.sh when ready."
  exit 1
fi

# Create config folder + save author
mkdir -p "$CONFIG_DIR"
echo "$AUTHOR_NAME" > "$AUTHOR_FILE"
echo "✅ Author name saved to $AUTHOR_FILE"

# Copy license templates into vault
mkdir -p "$LICENSE_DEST"
cp -r "$LICENSE_SRC"/* "$LICENSE_DEST"/
echo "📦 License templates copied from RepoForge-v2/dev__Starters to $LICENSE_DEST"

# Detect shell + target correct profile
SHELL_NAME=$(basename "$SHELL")
PROFILE_FILE="$HOME/.bashrc"
[[ "$SHELL_NAME" == "zsh" ]] && PROFILE_FILE="$HOME/.zshrc"

# Add alias to profile
ALIAS_CMD="alias forge='bash \"$INSTALL_DIR/forge.sh\"'"
if ! grep -Fxq "$ALIAS_CMD" "$PROFILE_FILE"; then
  echo "$ALIAS_CMD" >> "$PROFILE_FILE"
  echo "✅ Alias 'forge' added to $PROFILE_FILE"
  echo "💡 Run 'source $PROFILE_FILE' or restart your terminal to activate it."
else
  echo "ℹ️ Alias 'forge' already set in $PROFILE_FILE"
fi

# Done
echo "🎉 RepoForge is ready to use."
echo "👉 Run: forge"
exit 0
