#!/usr/bin/env bash
# Claude Code status line — mirrors Starship config layout:
# os | hostname | directory | git branch/status | time

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

# OS icon (macOS)
os_icon=""

# Hostname (short)
host=$(hostname -s)

# Directory: use cwd from Claude session
if [ -n "$cwd" ]; then
  dir="$cwd"
else
  dir=$(pwd)
fi
# Shorten home directory to ~
dir="${dir/#$HOME/\~}"

# Git branch and status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Check for dirty state
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
      git_info=" $branch !"
    else
      git_info=" $branch"
    fi
  fi
fi

# Time
time_str=$(date +%H:%M:%S)

printf "%s %s  %s%s  %s\n" "$os_icon" "$host" "$dir" "$git_info" "$time_str"
