#!/bin/bash

cd ../../..

source .env
forge create src/TheAscendantsAccessPass.sol:TheAscendantsAccessPass  \
  --rpc-url "$MAINNET_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 50 gwei)"\

# 0x6743e037c176caa49d495a3169f40779a8dc1a8c