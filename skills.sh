#!/bin/bash
# ConnectOS Skill Installer for Claude Code
# Usage: curl -sL https://raw.githubusercontent.com/ArshyaAI/connectos/main/skills.sh | bash

set -e

CURL_BIN="${CTOS_CURL_BIN:-curl}"
NPM_BIN="${CTOS_NPM_BIN:-npm}"
SKILL_URL="${CTOS_SKILL_URL:-https://raw.githubusercontent.com/ArshyaAI/ctos-skill/main/skills/ctos/SKILL.md}"
CLAUDE_SKILL_DIR="${CTOS_CLAUDE_SKILL_DIR:-$HOME/.claude/skills/ctos}"
SKIP_CLI_INSTALL="${CTOS_SKIP_CLI_INSTALL:-0}"
OPENCLAW_SKILL_DIRS="${CTOS_OPENCLAW_SKILL_DIRS:-}"

echo "Installing ConnectOS skill for Claude Code..."

# Install ctos CLI if not present
if [ "$SKIP_CLI_INSTALL" = "1" ]; then
  echo "  Skipping ctos CLI install (CTOS_SKIP_CLI_INSTALL=1)."
elif ! command -v ctos >/dev/null 2>&1; then
  echo "  Installing ctos CLI..."
  "$NPM_BIN" install -g @oysa/connectos 2>/dev/null
  echo "  ctos CLI installed."
else
  echo "  ctos CLI already installed."
fi

TARGET_DIRS="$CLAUDE_SKILL_DIR"

if [ -n "$OPENCLAW_SKILL_DIRS" ]; then
  OLD_IFS="$IFS"
  IFS=':'
  for _DIR in $OPENCLAW_SKILL_DIRS; do
    [ -n "$_DIR" ] && TARGET_DIRS="$TARGET_DIRS
$_DIR"
  done
  IFS="$OLD_IFS"
else
  for _DIR in \
    "$HOME/.openclaw/workspace/skills" \
    "/root/.openclaw/workspace/skills" \
    "/data/workspace/skills"
  do
    if [ -d "$_DIR" ]; then
      TARGET_DIRS="$TARGET_DIRS
$_DIR"
    fi
  done

  for _DIR in \
    "$HOME/.openclaw/workspace/agents"/*/skills \
    "/root/.openclaw/workspace/agents"/*/skills \
    "/data/workspace/agents"/*/skills
  do
    if [ -d "$_DIR" ]; then
      TARGET_DIRS="$TARGET_DIRS
$_DIR"
    fi
  done
fi

printf '%s\n' "$TARGET_DIRS" | while IFS= read -r SKILL_DIR; do
  [ -z "$SKILL_DIR" ] && continue
  mkdir -p "$SKILL_DIR"
  "$CURL_BIN" -sL "$SKILL_URL" -o "$SKILL_DIR/SKILL.md"
  echo "  Skill installed to $SKILL_DIR"
done

# Check config
if [ -f "$HOME/.ctosrc" ]; then
  echo "  ~/.ctosrc found — ready to use."
else
  echo "  ~/.ctosrc not found — run 'ctos init --url <url> --name <project> --bootstrap-secret <secret>' to configure."
fi

echo ""
echo "Done! Use /ctos in any Claude Code session to access your SaaS data."
