#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI_PATH="$ROOT_DIR/LocalPackages/MovieBrowserFeature/apollo-ios-cli"
CONFIG_PATH="$ROOT_DIR/LocalPackages/MovieBrowserFeature/apollo-codegen-config.json"

if [[ ! -x "$CLI_PATH" ]]; then
    echo "⚠️  Apollo CLI not found or not executable at $CLI_PATH" >&2
    exit 1
fi

if [[ ! -f "$CONFIG_PATH" ]]; then
    echo "⚠️  Apollo config not found at $CONFIG_PATH" >&2
    exit 1
fi

echo "🚀 Generating GraphQL API using $CONFIG_PATH"
"$CLI_PATH" generate --path "$CONFIG_PATH"
echo "✅ Apollo models regenerated."
