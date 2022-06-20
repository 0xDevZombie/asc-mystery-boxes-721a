#!/bin/bash

cd ../../..

source .env
forge create src/ClaimGiftOfMidas.sol:ClaimGiftOfMidas  \
  --constructor-args 0xf75cfbadc9b46e761fef827d34ebeca12a2a0a6b 0xD13A688156D0e124747C3f5da23C1527680f936b 6369 0x6168499c0cFfCaCD319c818142124B7A15E857ab 0x01BE23585060835E02B77ef475b0Cc51aA1e0709 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc\
  --rpc-url "$TESTNET_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY"\
  --optimizer-runs 200\
  --gas-price "$(cast to-wei 50 gwei)"\


# 0x242fa0457fc9f4ff762c786508f6857c338cf1dd