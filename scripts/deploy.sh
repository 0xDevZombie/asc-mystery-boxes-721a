#!/bin/bash

cd ..

source .env
forge create src/GiftOfMidas.sol:GiftOfMidas  \
  --constructor-args "contracttest" "TT" 0xD13A688156D0e124747C3f5da23C1527680f936b\
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 10 gwei)"\

