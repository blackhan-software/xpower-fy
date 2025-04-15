// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {NftTreasury} from "../../source/contracts/NftTreasury.sol";
import {APowerNft} from "../../source/contracts/APowerNft.sol";
import {console} from "forge-std/console.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        address nftLink = addressOf("XPOW_NFT_10a");
        address pptLink = addressOf("APOW_NFT_10a");
        address mtyLink = addressOf("XPOW_MTY_10a");
        ///
        vm.startBroadcast();
        NftTreasury nty = new NftTreasury(nftLink, pptLink, mtyLink);
        APowerNft(pptLink).transferOwnership(address(nty));
        vm.stopBroadcast();
        console_log(nty);
    }

    function console_log(NftTreasury nty) internal pure {
        console.log("APOW_NTY_10a", address(nty));
    }
}
