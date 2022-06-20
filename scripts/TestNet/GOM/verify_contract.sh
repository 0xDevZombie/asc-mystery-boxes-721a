#!/bin/bash

cd ../../..

source .env
forge verify-contract \
  --chain-id 4 \
  --num-of-optimizations 200 --constructor-args \
  "$(cast abi-encode "constructor(string,string,address)" "GiftOfMidas" "GOM" 0x22cB118163568d05C1285d9649Ca4f944DDc26D6)" \
  "$TESTNET_CONTRACT_ADDRESS" \
  src/GiftOfMidas.sol:GiftOfMidas \
  "$ETHERSCAN_TOKEN"
