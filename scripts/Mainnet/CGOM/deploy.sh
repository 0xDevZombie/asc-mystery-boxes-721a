#!/bin/bash

cd ../../..

source .env
forge create src/ClaimGiftOfMidas.sol:ClaimGiftOfMidas  \
  --constructor-args 0x567bba33030f1e5373407f7dea1f02f451527573 0x22cB118163568d05C1285d9649Ca4f944DDc26D6 189 0x271682DEB8C4E0901D1a1550aD2e64D568E69909 0x514910771af9ca656af840dff83e8264ecf986ca 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef\
  --rpc-url "$MAINNET_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 75 gwei)"\


# 0xfc9ab31a5eaa41b22f59c83de71f024e10a62ec0