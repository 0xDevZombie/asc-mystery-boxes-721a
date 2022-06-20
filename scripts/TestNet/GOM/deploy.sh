#!/bin/bash

cd ../../..

source .env
forge create src/GiftOfMidas.sol:GiftOfMidas  \
  --constructor-args "GiftOfMidas" "GOM" 0x22cB118163568d05C1285d9649Ca4f944DDc26D6\
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 50 gwei)"\

