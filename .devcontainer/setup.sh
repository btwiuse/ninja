#!/usr/bin/env bash

set -euxo pipefail

log() {
  echo -e "\033[1;32m[INFO]\033[0m $*"
}

err() {
  echo -e "\033[1;31m[ERROR]\033[0m $*" >&2
  exit 1
}

check_dependency() {
  command -v "$1" >/dev/null 2>&1 || err "$1 is not installed!"
}

install_injective_release() {
  log "Checking dependencies..."
  check_dependency gh
  check_dependency unzip
  check_dependency sudo

  log "Creating temporary directory..."
  tmpdir=$(mktemp -d)
  trap 'rm -rf "$tmpdir"' EXIT

  pushd "$tmpdir" >/dev/null

  log "Downloading latest Injective release..."
  gh release download --repo InjectiveLabs/injective-chain-releases --pattern "linux-amd64.zip"

  log "Unzipping archive..."
  unzip linux-amd64.zip

  log "Installing Injective binaries..."
  sudo install -m 755 injectived /usr/local/bin/
  sudo install -m 755 peggo /usr/local/bin/
  sudo install -m 644 libwasmvm.x86_64.so /usr/local/lib/
  sudo ldconfig

  log "Installed: injectived, peggo, libwasmvm.x86_64.so"

  popd >/dev/null
}

install_rust_and_targets() {
  log "Installing Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
  source "$HOME/.cargo/env"

  log "Adding wasm target..."
  rustup target add wasm32-unknown-unknown
}

install_ninja_tools() {
  log "Installing Ninja cargo-bin tools..."

  # Optional: Uncomment these to install from source instead
  # cargo install cargo-generate --features vendored-openssl
  # cargo install cargo-run-script
  # cargo install cosmwasm-check

  curl -sL https://github.com/btwiuse/ninja/releases/download/cargo-bin/cargo-bin.tgz | tar xvzC ~
}

install_foundry() {
  log "Installing Foundry..."
  curl -L https://foundry.paradigm.xyz | bash -v
  source "$HOME/.bashrc"
  curl -sL https://raw.githubusercontent.com/foundry-rs/foundry/master/foundryup/foundryup | bash
}

install_bun() {
  log "Installing Bun..."
  npm install -g bun
}

install_yj() {
  sudo curl -L https://github.com/sclevine/yj/releases/latest/download/yj-linux-amd64 -o /usr/local/bin/yj
  sudo chmod +x /usr/local/bin/yj
}

main() {
  echo 'set -o vi' >> ~/.bashrc
  install_injective_release
  install_rust_and_targets
  install_ninja_tools
  install_foundry
  install_bun
  install_yj
}

main "$@"
