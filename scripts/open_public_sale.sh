#!/bin/bash

cd ..

source .env

cast send "$CONTRACT_ADDRESS"  "togglePublicSaleOpen()" \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"\

