#!/bin/bash

cd ../../..

source .env

cast send 0xcde5b25057d8710183a0d217a655a1a75cb5d566 "setApprovalForAll(address, bool)" \
  0x242fa0457fc9f4ff762c786508f6857c338cf1dd true \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\

