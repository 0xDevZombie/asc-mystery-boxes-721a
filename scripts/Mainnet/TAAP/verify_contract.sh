#!/bin/bash

cd ../../..

source .env
forge verify-contract \
  --chain-id 1 \
  --num-of-optimizations 200 --constructor-args \
  "$(cast abi-encode "constructor()" "The Ascendants Access Pass" "TAAP")" \
  0x6743e037c176caa49d495a3169f40779a8dc1a8c \
  src/TheAscendantsAccessPass.sol:TheAscendantsAccessPass \
  "$ETHERSCAN_TOKEN"
