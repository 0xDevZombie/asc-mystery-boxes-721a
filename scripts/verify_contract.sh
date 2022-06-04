#!/bin/bash

cd ..

source .env
forge verify-contract \
  --chain-id 4 \
  --num-of-optimizations 200 --constructor-args \
  "$(cast abi-encode "constructor(string,string,address)" "forgeTest" "TT" 0xD13A688156D0e124747C3f5da23C1527680f936b)" \
  "$CONTRACT_ADDRESS" \
  src/GiftOfMidas.sol:GiftOfMidas \
  "$ETHERSCAN_TOKEN"


