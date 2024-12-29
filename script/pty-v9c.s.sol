// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {BaseScript} from "./base.s.sol";
import {console} from "forge-std/console.sol";
import {NftTreasury} from "../source/contracts/NftTreasury.sol";

contract Run is BaseScript {
    function run() external {
        address nftLink = addressOf("XPOW_NFT_V9c");
        address pptLink = addressOf("XPOW_PPT_V9c");
        address mtyLink = addressOf("XPOW_MTY_V9c");
        ///
        vm.startBroadcast();
        NftTreasury pty = new NftTreasury(
            nftLink, pptLink, mtyLink
        );
        vm.stopBroadcast();
        console_log(pty);
    }

    function console_log(NftTreasury pty) internal pure {
        console.log("XPOW_PTY_V9c_ADDRESS", address(pty));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years
}
