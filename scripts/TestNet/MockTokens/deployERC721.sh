#!/bin/bash

cd ../../..

source .env
forge create test/mocks/MockERC721.sol:MockERC721  \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 50 gwei)"\

# 0xcde5b25057d8710183a0d217a655a1a75cb5d566