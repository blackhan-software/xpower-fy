// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {APower} from "../source/contracts/APower.sol";
import {BaseScript} from "./base.s.sol";

contract Run is BaseScript {
    function run() external {
        APower sov = APower(addressOf("APOW_SOV_10a"));
        address boss = addressOf("BOSS_ADDRESS");
        ///
        vm.startBroadcast();
        sov.grantRole(sov.SOV_SEAL_ADMIN_ROLE(), boss);
        sov.grantRole(sov.DEFAULT_ADMIN_ROLE(), boss);
        vm.stopBroadcast();
        vm.startBroadcast();
        sov.renounceRole(sov.SOV_SEAL_ADMIN_ROLE(), msg.sender);
        sov.renounceRole(sov.DEFAULT_ADMIN_ROLE(), msg.sender);
        vm.stopBroadcast();
    }
}
