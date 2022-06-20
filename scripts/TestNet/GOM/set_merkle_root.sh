#!/bin/bash

cd ../../..

source .env

cast send "$CONTRACT_ADDRESS" "setMerkleRoot(bytes32)" \
  0x983aff872f5822b9e2c283a2f99c2c9baba208dc24c3f3a96bd3b8371a90aa75 \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"\

