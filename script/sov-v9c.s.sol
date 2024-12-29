// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {BaseScript} from "./base.s.sol";
import {console} from "forge-std/console.sol";
import {APower} from "../source/contracts/APower.sol";

contract Run is BaseScript {
    function run() external {
        address moeLink = addressOf("XPOW_MOE_V9c");
        ///
        address[] memory sovBase = new address[](20);
        sovBase[ 0] = addressOf("XPOW_SOV_V5a");
        sovBase[ 1] = addressOf("XPOW_SOV_V5b");
        sovBase[ 2] = addressOf("XPOW_SOV_V5c");
        sovBase[ 3] = addressOf("XPOW_SOV_V6a");
        sovBase[ 4] = addressOf("XPOW_SOV_V6b");
        sovBase[ 5] = addressOf("XPOW_SOV_V6c");
        sovBase[ 6] = addressOf("XPOW_SOV_V7a");
        sovBase[ 7] = addressOf("XPOW_SOV_V7b");
        sovBase[ 8] = addressOf("XPOW_SOV_V7c");
        sovBase[ 9] = addressOf("XPOW_SOV_V8a");
        sovBase[10] = addressOf("XPOW_SOV_V8b");
        sovBase[11] = addressOf("XPOW_SOV_V8c");
        sovBase[12] = addressOf("XPOW_SOV_V9a");
        sovBase[13] = addressOf("XPOW_SOV_V9b");
        sovBase[14] = addressOf("XPOW_SOV_V9c");
        ///
        vm.startBroadcast();
        APower sov = new APower(
            moeLink, sovBase, DEADLINE
        );
        vm.stopBroadcast();
        console_log(sov);
    }

    function console_log(APower sov) internal pure {
        console.log("XPOW_SOV_V9c_ADDRESS", address(sov));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years
}
