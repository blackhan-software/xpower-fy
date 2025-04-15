// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {XPowerNft} from "../source/contracts/XPowerNft.sol";
import {console} from "forge-std/console.sol";
import {BaseScript} from "./base.s.sol";

contract Run is BaseScript {
    function run() external {
        address moeLink = addressOf("XPOW_MOE_10a");
        ///
        string memory nftUri = stringOf("XPOW_NFT_URI");
        address[] memory nftBase = new address[](1);
        nftBase[0] = addressOf("XPOW_NFT_09c");
        ///
        vm.startBroadcast();
        XPowerNft nft = new XPowerNft(moeLink, nftUri, nftBase, DEADLINE);
        nft.transferOwnership(addressOf("BOSS_ADDRESS"));
        vm.stopBroadcast();
        console_log(nft);
    }

    function console_log(XPowerNft nft) internal pure {
        console.log("XPOW_NFT_10a", address(nft));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years (or less)
}
