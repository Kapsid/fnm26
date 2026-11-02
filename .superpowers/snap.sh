#!/bin/bash
# Snapshot the whole working tree as a dangling commit, without touching the real index.
set -e
cd /Users/martinurbanczyk/Documents/Work/fnm26
tmp=$(mktemp)
cp .git/index "$tmp"
GIT_INDEX_FILE="$tmp" git add -A
tree=$(GIT_INDEX_FILE="$tmp" git write-tree)
rm -f "$tmp"
git commit-tree "$tree" -p HEAD -m "snapshot: $1"
