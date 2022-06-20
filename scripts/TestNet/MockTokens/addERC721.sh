#!/bin/bash

cd ../../..

source .env

cast send 0x242fa0457fc9f4ff762c786508f6857c338cf1dd "addLegendaryPrize(address, uint)" \
  0xcde5b25057d8710183a0d217a655a1a75cb5d566 1 \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\

