#!/bin/bash

cd ..

source .env

cast send "$CONTRACT_ADDRESS" "setMerkleRoot(bytes32)" \
  0xcc62861ddd46327e4e613be2e7e153e6b5c633c56d6c96566adc187aaad19857 \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"\

