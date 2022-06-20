#!/bin/bash

cd ../../../..

source .env
forge create test/mocks/MockERC1155.sol:MockERC1155  \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 50 gwei)"\

# 0xf104b40fbc5cfc0904f978f52e3336ea0639cc95