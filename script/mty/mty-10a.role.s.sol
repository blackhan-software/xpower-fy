// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {MoeTreasury} from "../../source/contracts/MoeTreasury.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        MoeTreasury mty = MoeTreasury(addressOf("XPOW_MTY_10a"));
        address boss = addressOf("BOSS_ADDRESS");
        ///
        vm.startBroadcast();
        mty.grantRole(mty.APR_ADMIN_ROLE(), boss);
        mty.grantRole(mty.APB_ADMIN_ROLE(), boss);
        mty.grantRole(mty.DEFAULT_ADMIN_ROLE(), boss);
        vm.stopBroadcast();
        vm.startBroadcast();
        mty.renounceRole(mty.APR_ADMIN_ROLE(), msg.sender);
        mty.renounceRole(mty.APB_ADMIN_ROLE(), msg.sender);
        mty.renounceRole(mty.DEFAULT_ADMIN_ROLE(), msg.sender);
        vm.stopBroadcast();
    }
}
