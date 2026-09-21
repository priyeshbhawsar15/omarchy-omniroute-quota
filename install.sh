#!/usr/bin/env bash
set -euo pipefail
dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$dir/bin/omniroute-quota"
mkdir -p "$HOME/.local/bin"
ln -sf "$dir/bin/omniroute-quota" "$HOME/.local/bin/omniroute-quota"
