// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {XPower} from "../../source/contracts/XPower.sol";
import {console} from "forge-std/console.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        address[] memory moeBase = new address[](1);
        moeBase[0] = addressOf("XPOW_MOE_09c");
        ///
        vm.startBroadcast();
        XPower moe = new XPower(moeBase, DEADLINE);
        vm.stopBroadcast();
        console_log(moe);
    }

    function console_log(XPower moe) internal pure {
        console.log("XPOW_MOE_10a", address(moe));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years (or less)
}
