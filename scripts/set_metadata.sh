#!/bin/bash

cd ..

source .env

cast send "$CONTRACT_ADDRESS" "setURI(string)" \
  "ipfs://QmSqGeia2X4wJkwTTFW2h1NpFPpWU94gcZRoFi2xrVvBTL/" \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"\

