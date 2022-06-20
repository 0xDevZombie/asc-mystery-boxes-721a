#!/bin/bash

cd ../../..

source .env

cast send 0x242fa0457fc9f4ff762c786508f6857c338cf1dd "generateWinners()" \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\

