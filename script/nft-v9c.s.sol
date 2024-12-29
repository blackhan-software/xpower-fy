// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {BaseScript} from "./base.s.sol";
import {console} from "forge-std/console.sol";
import {XPowerNft} from "../source/contracts/XPowerNft.sol";

contract Run is BaseScript {
    function run() external {
        address moeLink = addressOf("XPOW_MOE_V9c");
        ///
        string memory nftUri = stringOf("XPOW_NFT_URI");
        address[] memory nftBase = new address[](20);
        nftBase[ 0] = addressOf("XPOW_NFT_V2a");
        nftBase[ 1] = addressOf("XPOW_NFT_V2b");
        nftBase[ 2] = addressOf("XPOW_NFT_V2c");
        nftBase[ 3] = addressOf("XPOW_NFT_V3a");
        nftBase[ 4] = addressOf("XPOW_NFT_V3b");
        nftBase[ 5] = addressOf("XPOW_NFT_V4a");
        nftBase[ 6] = addressOf("XPOW_NFT_V5a");
        nftBase[ 7] = addressOf("XPOW_NFT_V5b");
        nftBase[ 8] = addressOf("XPOW_NFT_V5c");
        nftBase[ 9] = addressOf("XPOW_NFT_V6a");
        nftBase[10] = addressOf("XPOW_NFT_V6b");
        nftBase[11] = addressOf("XPOW_NFT_V6c");
        nftBase[12] = addressOf("XPOW_NFT_V7a");
        nftBase[13] = addressOf("XPOW_NFT_V7b");
        nftBase[14] = addressOf("XPOW_NFT_V7c");
        nftBase[15] = addressOf("XPOW_NFT_V8a");
        nftBase[16] = addressOf("XPOW_NFT_V8b");
        nftBase[17] = addressOf("XPOW_NFT_V8c");
        nftBase[18] = addressOf("XPOW_NFT_V9a");
        nftBase[19] = addressOf("XPOW_NFT_V9b");
        ///
        vm.startBroadcast();
        XPowerNft nft = new XPowerNft(
            moeLink, nftUri, nftBase, DEADLINE
        );
        vm.stopBroadcast();
        console_log(nft);
    }

    function console_log(XPowerNft nft) internal pure {
        console.log("XPOW_NFT_V9c_ADDRESS", address(nft));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years
}
