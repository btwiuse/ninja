type install_everything
install_injective_release
install_rust_and_targets
install_cosmwasm_tools
install_dotfiles
install_foundry
install_bun
install_yj

rustup target list --installed
rustup toolchain list

injectived version
injectived --help
injectived keys list
injectived keys add account
injectived keys list --output json | jq .

cargo generate --git https://github.com/CosmWasm/cw-template.git --name counter --define minimal=false
cargo generate --git https://github.com/CosmWasm/cw-template.git --name minimal --define minimal=true

cargo wasm
cargo schema

docker run --rm -v "$(pwd)":/code --mount type=volume,source="$(basename "$(pwd)")_cache",target=/target --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry cosmwasm/optimizer:0.16.1
