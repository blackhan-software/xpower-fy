// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {BaseScript} from "./base.s.sol";
import {console} from "forge-std/console.sol";
import {MoeTreasury} from "../source/contracts/MoeTreasury.sol";

contract Run is BaseScript {
    function run() external {
        address moeLink = addressOf("XPOW_MOE_V9c");
        address sovLink = addressOf("XPOW_SOV_V9c");
        address pptLink = addressOf("XPOW_PPT_V9c");
        ///
        vm.startBroadcast();
        MoeTreasury mty = new MoeTreasury(
            moeLink, sovLink, pptLink
        );
        vm.stopBroadcast();
        console_log(mty);
    }

    function console_log(MoeTreasury mty) internal pure {
        console.log("XPOW_MTY_V9c_ADDRESS", address(mty));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years
}
