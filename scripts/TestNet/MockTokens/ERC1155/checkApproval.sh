#!/bin/bash

cd ../../../..

source .env

cast call 0xf104b40fbc5cfc0904f978f52e3336ea0639cc95 "isApprovedForAll(address, address)" \
  0xD13A688156D0e124747C3f5da23C1527680f936b 0x242fa0457fc9f4ff762c786508f6857c338cf1dd \
  --rpc-url "$TESTNET_RPC_URL" \


