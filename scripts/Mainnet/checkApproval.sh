#!/bin/bash

cd ../..

source .env

ADDR="0x943f4f7fc2D48F3AD8C524cf8A8794B64100df3F 0x160C404B2b49CBC3240055CEaEE026df1e8497A0 0x9df8Aa7C681f33E442A0d57B838555da863504f3 0x648E8428e0104Ec7D08667866a3568a72Fe3898F 0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e 0xEDc3AD89f7b0963fe23D714B34185713706B815b"
for a in $ADDR
do
   cast call "$a" "isApprovedForAll(address, address)" 0x22cB118163568d05C1285d9649Ca4f944DDc26D6 0xfc9ab31a5eaa41b22f59c83de71f024e10a62ec0  --rpc-url "$MAINNET_RPC_URL"


done