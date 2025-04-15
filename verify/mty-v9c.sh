#!/usr/bin/env bash
source .env

CHAIN_ID=${1-"43114"} # use 43113 (for testnet)
CTOR_ARGS=$(cast abi-encode "constructor(address,address,address)" \
    $XPOW_MOE_V9c \
    $XPOW_SOV_V9c \
    $XPOW_PPT_V9c \
)

forge verify-contract \
    --chain-id $CHAIN_ID \
    --constructor-args $CTOR_ARGS \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --compiler-version v0.8.20+commit.a1b79de6 \
    --watch \
    $XPOW_MTY_V9c \
    source/contracts/MoeTreasury.sol:MoeTreasury
