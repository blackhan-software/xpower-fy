// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {XPower} from "../source/contracts/XPower.sol";
import {BaseScript} from "./base.s.sol";

contract Run is BaseScript {
    function run() external {
        XPower moe = XPower(addressOf("XPOW_MOE_10a"));
        address boss = addressOf("BOSS_ADDRESS");
        ///
        vm.startBroadcast();
        moe.grantRole(moe.MOE_SEAL_ADMIN_ROLE(), boss);
        moe.grantRole(moe.DEFAULT_ADMIN_ROLE(), boss);
        vm.stopBroadcast();
        vm.startBroadcast();
        moe.renounceRole(moe.MOE_SEAL_ADMIN_ROLE(), msg.sender);
        moe.renounceRole(moe.DEFAULT_ADMIN_ROLE(), msg.sender);
        vm.stopBroadcast();
    }
}
