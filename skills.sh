#!/bin/bash
# ConnectOS Skill Installer for Claude Code
# Usage: curl -sL https://raw.githubusercontent.com/ArshyaAI/ctos-skill/main/skills.sh | bash

set -e

SKILL_DIR="$HOME/.claude/skills/ctos"
SKILL_URL="https://raw.githubusercontent.com/ArshyaAI/ctos-skill/main/skills/ctos/SKILL.md"

echo "Installing ConnectOS skill for Claude Code..."

# Install ctos CLI if not present
if ! command -v ctos >/dev/null 2>&1; then
  echo "  Installing ctos CLI..."
  npm install -g @oysa/connectos --force 2>/dev/null
  echo "  ctos CLI installed."
else
  echo "  ctos CLI already installed."
fi

# Install skill
mkdir -p "$SKILL_DIR"
curl -sL "$SKILL_URL" -o "$SKILL_DIR/SKILL.md"
echo "  Skill installed to $SKILL_DIR"

# Check config
if [ -f "$HOME/.ctosrc" ]; then
  echo "  ~/.ctosrc found — ready to use."
else
  echo "  ~/.ctosrc not found — run 'ctos init --bootstrap-secret <secret>' to configure."
  echo "  (Only the bootstrap secret is required. URL and name are auto-detected.)"
fi

echo ""
echo "Done! Use /ctos in any Claude Code session to access your SaaS data."
