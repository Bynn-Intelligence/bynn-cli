#!/usr/bin/env sh
# Installer for the BYNN Intelligence CLI.
# Usage: curl -fsSL https://raw.githubusercontent.com/Bynn-Intelligence/bynn-cli/main/install.sh | sh
set -eu

REPO="Bynn-Intelligence/bynn-cli"
BINARY="bynn"

# --- detect platform -----------------------------------------------------
uname_s="$(uname -s)"
uname_m="$(uname -m)"

case "$uname_s" in
  Darwin) os="darwin" ;;
  Linux)  os="linux"  ;;
  *) echo "install.sh: unsupported OS: $uname_s" >&2; exit 1 ;;
esac

case "$uname_m" in
  x86_64|amd64) arch="amd64" ;;
  arm64|aarch64) arch="arm64" ;;
  *) echo "install.sh: unsupported architecture: $uname_m" >&2; exit 1 ;;
esac

# --- resolve install dir -------------------------------------------------
if [ -w "/usr/local/bin" ] 2>/dev/null; then
  install_dir="/usr/local/bin"
elif command -v sudo >/dev/null 2>&1 && [ -d "/usr/local/bin" ]; then
  install_dir="/usr/local/bin"
  use_sudo=1
else
  install_dir="$HOME/.local/bin"
  mkdir -p "$install_dir"
fi

# --- pick latest release tag --------------------------------------------
tag="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' \
  | head -n 1)"

if [ -z "${tag:-}" ]; then
  echo "install.sh: failed to find latest release for $REPO" >&2
  exit 1
fi

version="${tag#v}"
asset="${BINARY}_${version}_${os}_${arch}.tar.gz"
url="https://github.com/$REPO/releases/download/${tag}/${asset}"

# --- download + extract --------------------------------------------------
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "==> Downloading ${asset}"
curl -fsSL --retry 3 -o "$tmp/$asset" "$url"

echo "==> Extracting"
tar -xzf "$tmp/$asset" -C "$tmp"

echo "==> Installing to $install_dir/$BINARY"
if [ "${use_sudo:-0}" = "1" ]; then
  sudo install -m 0755 "$tmp/$BINARY" "$install_dir/$BINARY"
else
  install -m 0755 "$tmp/$BINARY" "$install_dir/$BINARY"
fi

echo
echo "Installed: $($install_dir/$BINARY version 2>/dev/null || echo "$install_dir/$BINARY")"
case ":$PATH:" in
  *":$install_dir:"*) ;;
  *) echo "note: $install_dir is not on your PATH; add it to your shell rc to use bynn directly." ;;
esac
