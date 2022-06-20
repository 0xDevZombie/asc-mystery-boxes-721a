#!/bin/bash

cd ../../..

source .env

cast call 0xcde5b25057d8710183a0d217a655a1a75cb5d566 "isApprovedForAll(address, address)" \
  0xD13A688156D0e124747C3f5da23C1527680f936b 0x242fa0457fc9f4ff762c786508f6857c338cf1dd \
  --rpc-url "$TESTNET_RPC_URL" \


