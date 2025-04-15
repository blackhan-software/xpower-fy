#!/usr/bin/env bash
source .env

CHAIN_ID=${1-"43114"} # use 43113 (for testnet)
CTOR_ARGS=$(cast abi-encode "constructor(address[] memory,uint256)" \
    [$XPOW_MOE_V1a,$XPOW_MOE_V2a,$XPOW_MOE_V3a,$XPOW_MOE_V4a,$XPOW_MOE_V5a,$XPOW_MOE_V5b,$XPOW_MOE_V5c,$XPOW_MOE_V6a,$XPOW_MOE_V6b,$XPOW_MOE_V6c,$XPOW_MOE_V7a,$XPOW_MOE_V7b,$XPOW_MOE_V7c,$XPOW_MOE_V8a,$XPOW_MOE_V8b,$XPOW_MOE_V8c,$XPOW_MOE_V9a,$XPOW_MOE_V9b] \
    126230400 \
)

forge verify-contract \
    --chain-id $CHAIN_ID \
    --constructor-args $CTOR_ARGS \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --compiler-version v0.8.20+commit.a1b79de6 \
    --watch \
    $XPOW_MOE_V9c \
    source/contracts/XPower.sol:XPower
