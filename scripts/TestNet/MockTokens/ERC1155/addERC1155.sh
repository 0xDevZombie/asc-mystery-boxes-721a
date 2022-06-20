#!/bin/bash

cd ../../../..

source .env

cast send 0x242fa0457fc9f4ff762c786508f6857c338cf1dd "addCommonPrize(address, uint, uint)" \
  0xf104b40fbc5cfc0904f978f52e3336ea0639cc95 3 9 \
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\

