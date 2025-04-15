#!/usr/bin/env bash
source .env

CHAIN_ID=${1-"43114"} # use 43113 (for testnet)

forge verify-contract \
    --chain-id $CHAIN_ID \
    --guess-constructor-args \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --compiler-version v0.8.29+commit.ab55807c \
    --watch \
    $APOW_NFT_10a \
    source/contracts/APowerNft.sol:APowerNft
