#!/bin/bash

# ===============================================
# 🚀 RepoForge — spawn.sh
# Spawns a new repo with license, readme, and git.
# ===============================================

# === CONFIG ===
AUTHOR_FILE="$HOME/.repoforge/.author"
YEAR=$(date +%Y)
LICENSE_TYPE="$1"
REPO_NAME="$2"
TARGET_DIR="$HOME/Desktop/$REPO_NAME"
SOURCE_DIR="$HOME/Desktop/dev__Starters/licenses/$LICENSE_TYPE"

# === Validate inputs ===
if [[ -z "$LICENSE_TYPE" || -z "$REPO_NAME" ]]; then
  echo "❌ Usage: ./spawn.sh <license> <repo-name>"
  exit 1
fi

if [[ ! -f "$AUTHOR_FILE" ]]; then
  echo "❌ Author not set. Please run ./install.sh first."
  exit 1
fi

AUTHOR=$(cat "$AUTHOR_FILE")

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "❌ License type '$LICENSE_TYPE' does not exist."
  exit 1
fi

# === Create repo ===
cp -r "$SOURCE_DIR" "$TARGET_DIR"

# === Inject dynamic values ===
sed -i "s/{{PROJECT_NAME}}/$REPO_NAME/g" "$TARGET_DIR/README.md"
sed -i "s/{{YEAR}}/$YEAR/g" "$TARGET_DIR/LICENSE"
sed -i "s/{{AUTHOR}}/$AUTHOR/g" "$TARGET_DIR/LICENSE"

# === Add .bw_hash ===
if [[ -f "$SOURCE_DIR/.bw_hash" ]]; then
  cp "$SOURCE_DIR/.bw_hash" "$TARGET_DIR/.bw_hash"
else
  echo "⚠️  No .bw_hash found in $SOURCE_DIR"
fi

# === Init git ===
cd "$TARGET_DIR"
git init
git add .
git commit -m "📦 Repo initialized via CLI Spawn | BuiltByWill.dev"

# === Launch in VS Code ===
code .

echo "✅ $REPO_NAME created with $LICENSE_TYPE license and launched in VS Code."
