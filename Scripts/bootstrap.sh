#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v tuist >/dev/null 2>&1; then
  echo "Installing Tuist..."
  curl -Ls https://install.tuist.io | bash
  export PATH="$HOME/.tuist/bin:$PATH"
fi

echo "Resolving Tuist dependencies..."
tuist install

echo "Generating the Xcode workspace..."
tuist generate
