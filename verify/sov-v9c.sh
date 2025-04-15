#!/usr/bin/env bash
source .env

CHAIN_ID=${1-"43114"} # use 43113 (for testnet)
CTOR_ARGS=$(cast abi-encode "constructor(address,address[] memory,uint256)" \
    $XPOW_MOE_V9c \
    [$XPOW_SOV_V5a,$XPOW_SOV_V5b,$XPOW_SOV_V5c,$XPOW_SOV_V6a,$XPOW_SOV_V6b,$XPOW_SOV_V6c,$XPOW_SOV_V7a,$XPOW_SOV_V7b,$XPOW_SOV_V7c,$XPOW_SOV_V8a,$XPOW_SOV_V8b,$XPOW_SOV_V8c,$XPOW_SOV_V9a,$XPOW_SOV_V9b] \
    126230400 \
)

forge verify-contract \
    --chain-id $CHAIN_ID \
    --constructor-args $CTOR_ARGS \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --compiler-version v0.8.20+commit.a1b79de6 \
    --watch \
    $XPOW_SOV_V9c \
    source/contracts/APower.sol:APower
