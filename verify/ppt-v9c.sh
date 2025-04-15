#!/usr/bin/env bash
source .env

CHAIN_ID=${1-"43114"} # use 43113 (for testnet)
CTOR_ARGS=$(cast abi-encode "constructor(string memory,address[] memory,uint256)" \
    $XPOW_PPT_URI \
    [$XPOW_PPT_V4a,$XPOW_PPT_V5a,$XPOW_PPT_V5b,$XPOW_PPT_V5c,$XPOW_PPT_V6a,$XPOW_PPT_V6b,$XPOW_PPT_V6c,$XPOW_PPT_V7a,$XPOW_PPT_V7b,$XPOW_PPT_V7c,$XPOW_PPT_V8a,$XPOW_PPT_V8b,$XPOW_PPT_V8c,$XPOW_PPT_V9a,$XPOW_PPT_V9b] \
    126230400 \
)

forge verify-contract \
    --chain-id $CHAIN_ID \
    --constructor-args $CTOR_ARGS \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --compiler-version v0.8.20+commit.a1b79de6 \
    --watch \
    $XPOW_PPT_V9c \
    source/contracts/XPowerPpt.sol:XPowerPpt
