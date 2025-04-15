// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {BaseScript} from "./base.s.sol";
import {console} from "forge-std/console.sol";
import {XPower} from "../source/contracts/XPower.sol";

contract Run is BaseScript {
    function run() external {
        ///
        address[] memory moeBase = new address[](18);
        moeBase[ 0] = addressOf("XPOW_MOE_V1a");
        moeBase[ 1] = addressOf("XPOW_MOE_V2a");
        moeBase[ 2] = addressOf("XPOW_MOE_V3a");
        moeBase[ 3] = addressOf("XPOW_MOE_V4a");
        moeBase[ 4] = addressOf("XPOW_MOE_V5a");
        moeBase[ 5] = addressOf("XPOW_MOE_V5b");
        moeBase[ 6] = addressOf("XPOW_MOE_V5c");
        moeBase[ 7] = addressOf("XPOW_MOE_V6a");
        moeBase[ 8] = addressOf("XPOW_MOE_V6b");
        moeBase[ 9] = addressOf("XPOW_MOE_V6c");
        moeBase[10] = addressOf("XPOW_MOE_V7a");
        moeBase[11] = addressOf("XPOW_MOE_V7b");
        moeBase[12] = addressOf("XPOW_MOE_V7c");
        moeBase[13] = addressOf("XPOW_MOE_V8a");
        moeBase[14] = addressOf("XPOW_MOE_V8b");
        moeBase[15] = addressOf("XPOW_MOE_V8c");
        moeBase[16] = addressOf("XPOW_MOE_V9a");
        moeBase[17] = addressOf("XPOW_MOE_V9b");
        ///
        vm.startBroadcast();
        XPower moe = new XPower(moeBase, DEADLINE);
        vm.stopBroadcast();
        console_log(moe);
    }

    function console_log(XPower moe) internal pure {
        console.log("XPOW_MOE_V9c_ADDRESS", address(moe));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years
}
