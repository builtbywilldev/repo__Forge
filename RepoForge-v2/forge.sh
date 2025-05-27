#!/bin/bash

# =====================================================
# 🔨 RepoForge — Interactive Repository Spawner
# forge.sh
# Prompts user to generate a full branded repo scaffold
# =====================================================

# === CONFIG ===
AUTHOR_FILE="$HOME/.repoforge/.author"
LICENSE_DIR="$HOME/.repoforge/licenses"
YEAR=$(date +%Y)

# === Check for Author ===
if [[ ! -f "$AUTHOR_FILE" ]]; then
  echo "❌ Author not set. Please run ./install.sh first."
  exit 1
fi

AUTHOR=$(cat "$AUTHOR_FILE")

echo -e "\n🔧 Welcome to RepoForge"
echo "🚀 Let's forge your next repo."

# === User Inputs ===
read -p "📝 Repo name: " REPO_NAME
REPO_PATH="$HOME/Desktop/$REPO_NAME"

read -p "🔐 License type (mit, gpl, apache, unlicense, proprietary): " LICENSE_TYPE
TEMPLATE_PATH="$LICENSE_DIR/$LICENSE_TYPE"

if [[ ! -d "$TEMPLATE_PATH" ]]; then
  echo "❌ License type '$LICENSE_TYPE' not found."
  exit 1
fi

read -p "📄 Include .gitignore? (y/n): " ADD_GITIGNORE
read -p "📘 Include README.md? (y/n): " ADD_README

# === Create and Populate Repo ===
mkdir -p "$REPO_PATH"
cp "$TEMPLATE_PATH/LICENSE" "$REPO_PATH/"
sed -i "s/{{YEAR}}/$YEAR/g; s/{{AUTHOR}}/$AUTHOR/g" "$REPO_PATH/LICENSE"

if [[ "$ADD_GITIGNORE" == "y" ]]; then
  cp "$TEMPLATE_PATH/.gitignore" "$REPO_PATH/"
fi

if [[ "$ADD_README" == "y" ]]; then
  cp "$TEMPLATE_PATH/README.md" "$REPO_PATH/"
  sed -i "s/{{PROJECT_NAME}}/$REPO_NAME/g" "$REPO_PATH/README.md"
fi

cp "$TEMPLATE_PATH/.bw-hash" "$REPO_PATH/"

# === Git Init ===
cd "$REPO_PATH"
git init
git add .
git commit -m "📦 Repo initialized via RepoForge | License: $LICENSE_TYPE"

# === Open in VS Code ===
code .

# === Done ===
echo -e "\n✅ Repo '$REPO_NAME' created and launched."
echo "🧠 Branded by BuiltByWill | Terminal–Forged | Phase–Coded"
