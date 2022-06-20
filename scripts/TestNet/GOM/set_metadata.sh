#!/bin/bash

cd ../../..

source .env

cast send "$CONTRACT_ADDRESS" "setURI(string)" \
  "ipfs://QmRbtRCBPEKxYtCQED9BY6UGASWDMNBc2NYbRu94Swaacm/" \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"\

