#!/bin/bash

cd ../../..

source .env
forge create src/TheAscendantsAccessPass.sol:TheAscendantsAccessPass  \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 50 gwei)"\

