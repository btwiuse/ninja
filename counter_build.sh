#!/usr/bin/env bash

set -e

[[ -d counter ]] || {
  cargo generate --git https://github.com/CosmWasm/cw-template.git --name counter --define minimal=false # --branch 1.0
  pushd counter
  cargo wasm
  cargo schema
  docker run --rm -v "$(pwd)":/code \
    --mount type=volume,source="$(basename "$(pwd)")_cache",target=/target \
    --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
    cosmwasm/optimizer:0.16.1
  popd
}
