#!/bin/bash

cd ../../..

source .env

cast send 0xcde5b25057d8710183a0d217a655a1a75cb5d566 "mint()" \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\

