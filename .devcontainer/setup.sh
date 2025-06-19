#!/usr/bin/env bash

install_injective_release() {
  set -e

  # Create temp dir and move into it
  tmpdir=$(mktemp -d)
  pushd "$tmpdir" > /dev/null

  # Ensure gh is installed
  if ! command -v gh &> /dev/null; then
    echo "gh CLI not found!"
    return 1
  fi

  echo "Downloading latest injective release..."
  gh release download --repo InjectiveLabs/injective-chain-releases --pattern "linux-amd64.zip"

  echo "Unzipping..."
  unzip linux-amd64.zip

  echo "Installing binaries..."
  sudo install -m 755 injectived /usr/local/bin/
  sudo install -m 755 peggo /usr/local/bin/
  sudo install -m 644 libwasmvm.x86_64.so /usr/local/lib/
  sudo ldconfig

  echo "Installed: injectived, peggo, libwasmvm.x86_64.so"

  # Cleanup
  popd > /dev/null
  rm -rf "$tmpdir"
}

install_injective_release

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
source $HOME/.cargo/env
rustup target add wasm32-unknown-unknown

curl -L https://foundry.paradigm.xyz | bash
$HOME/.foundry/bin/foundryup

npm i -g bun

# cargo install cargo-generate --features vendored-openssl
# cargo install cargo-run-script
# cargo install cosmwasm-check

curl -sL https://github.com/btwiuse/ninja/releases/download/cargo-bin/cargo-bin.tgz | tar xvzC ~