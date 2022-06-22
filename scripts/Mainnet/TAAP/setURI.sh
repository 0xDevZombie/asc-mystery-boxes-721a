#!/bin/bash

cd ../../..

source .env


cast send 0x6743E037C176CAA49d495a3169F40779a8Dc1a8C "setTokenIdToUri(uint256, string)" \
  1 \
  "ipfs://QmbADAYfn3A4NbqHtvnQFrrfxJLbp6J8K5eVHUhwaipdGP/" \
  --rpc-url "$MAINNET_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY"\
  --gas-price "$(cast to-wei 50 gwei)"

cast send 0x6743E037C176CAA49d495a3169F40779a8Dc1a8C "setTokenIdToUri(uint256, string)" \
  2 \
  "ipfs://QmR92nUJuz4QBXwcD5suFxF7jwagAPwRixAZfPHZfvEXMT/" \
  --rpc-url "$MAINNET_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY"\
  --gas-price "$(cast to-wei 50 gwei)"

cast send 0x6743E037C176CAA49d495a3169F40779a8Dc1a8C "setTokenIdToUri(uint256, string)" \
  3 \
  "ipfs://QmbQxgk4zY8jz7hNcWNJ9t342CFQciN4dEmiarUVi99eMa/" \
  --rpc-url "$MAINNET_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY"\
  --gas-price "$(cast to-wei 50 gwei)"