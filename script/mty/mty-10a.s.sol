// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {MoeTreasury} from "../../source/contracts/MoeTreasury.sol";
import {XPower} from "../../source/contracts/XPower.sol";
import {APower} from "../../source/contracts/APower.sol";
import {console} from "forge-std/console.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        address moeLink = addressOf("XPOW_MOE_10a");
        address sovLink = addressOf("APOW_SOV_10a");
        address pptLink = addressOf("APOW_NFT_10a");
        ///
        vm.startBroadcast();
        MoeTreasury mty = new MoeTreasury(moeLink, sovLink, pptLink);
        XPower(moeLink).transferOwnership(address(mty));
        APower(sovLink).transferOwnership(address(mty));
        vm.stopBroadcast();
        console_log(mty);
    }

    function console_log(MoeTreasury mty) internal pure {
        console.log("XPOW_MTY_10a", address(mty));
    }
}
