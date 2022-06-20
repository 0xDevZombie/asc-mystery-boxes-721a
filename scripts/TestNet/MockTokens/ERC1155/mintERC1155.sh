#!/bin/bash

cd ../../../..

source .env

cast send 0xf104b40fbc5cfc0904f978f52e3336ea0639cc95 "mint(uint256, uint256)" \
  3 9 \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\

