#!/bin/bash

cd ../../..

source .env
forge verify-contract \
  --chain-id 4 \
  --num-of-optimizations 200 --constructor-args \
  "$(cast abi-encode "constructor()" "The Ascendants Access Pass" "TAAP")" \
  0x4f640361e45e0020e2946fcd876c3b873a556317 \
  src/TheAscendantsAccessPass.sol:TheAscendantsAccessPass \
  "$ETHERSCAN_TOKEN"
