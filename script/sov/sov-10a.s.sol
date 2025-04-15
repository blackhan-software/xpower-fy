// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {APower} from "../../source/contracts/APower.sol";
import {console} from "forge-std/console.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        address moeLink = addressOf("XPOW_MOE_10a");
        ///
        address[] memory sovBase = new address[](1);
        sovBase[0] = addressOf("APOW_SOV_09c");
        ///
        vm.startBroadcast();
        APower sov = new APower(moeLink, sovBase, DEADLINE);
        vm.stopBroadcast();
        console_log(sov);
    }

    function console_log(APower sov) internal pure {
        console.log("APOW_SOV_10a", address(sov));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years (or less)
}
