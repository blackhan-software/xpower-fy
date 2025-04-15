#!/usr/bin/env bash
source .env

CHAIN_ID=${1-"43114"} # use 43113 (for testnet)
CTOR_ARGS=$(cast abi-encode "constructor(address,string memory,address[] memory,uint256)" \
    $XPOW_MOE_V9c \
    $XPOW_NFT_URI \
    [$XPOW_NFT_V2a,$XPOW_NFT_V2b,$XPOW_NFT_V2c,$XPOW_NFT_V3a,$XPOW_NFT_V3b,$XPOW_NFT_V4a,$XPOW_NFT_V5a,$XPOW_NFT_V5b,$XPOW_NFT_V5c,$XPOW_NFT_V6a,$XPOW_NFT_V6b,$XPOW_NFT_V6c,$XPOW_NFT_V7a,$XPOW_NFT_V7b,$XPOW_NFT_V7c,$XPOW_NFT_V8a,$XPOW_NFT_V8b,$XPOW_NFT_V8c,$XPOW_NFT_V9a,$XPOW_NFT_V9b] \
    126230400 \
)

forge verify-contract \
    --chain-id $CHAIN_ID \
    --constructor-args $CTOR_ARGS \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --compiler-version v0.8.20+commit.a1b79de6 \
    --watch \
    $XPOW_NFT_V9c \
    source/contracts/XPowerNft.sol:XPowerNft
