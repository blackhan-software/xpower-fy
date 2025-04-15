// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {MoeTreasury} from "../../source/contracts/MoeTreasury.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run(uint256 nft_id) external {
        MoeTreasury mty = MoeTreasury(addressOf("XPOW_MTY_10a"));
        ///
        vm.startBroadcast();
        mty.claim(msg.sender, nft_id, type(uint256).max, 0);
        vm.stopBroadcast();
    }
}
