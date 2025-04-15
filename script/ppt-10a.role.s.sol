// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {APowerNft} from "../source/contracts/APowerNft.sol";
import {BaseScript} from "./base.s.sol";

contract Run is BaseScript {
    function run() external {
        APowerNft ppt = APowerNft(addressOf("APOW_NFT_10a"));
        address boss = addressOf("BOSS_ADDRESS");
        ///
        vm.startBroadcast();
        ppt.grantRole(ppt.NFT_ROYAL_ADMIN_ROLE(), boss);
        ppt.grantRole(ppt.NFT_OPEN_ADMIN_ROLE(), boss);
        ppt.grantRole(ppt.NFT_SEAL_ADMIN_ROLE(), boss);
        ppt.grantRole(ppt.URI_DATA_ADMIN_ROLE(), boss);
        ppt.grantRole(ppt.DEFAULT_ADMIN_ROLE(), boss);
        vm.stopBroadcast();
        vm.startBroadcast();
        ppt.renounceRole(ppt.NFT_ROYAL_ADMIN_ROLE(), msg.sender);
        ppt.renounceRole(ppt.NFT_OPEN_ADMIN_ROLE(), msg.sender);
        ppt.renounceRole(ppt.NFT_SEAL_ADMIN_ROLE(), msg.sender);
        ppt.renounceRole(ppt.URI_DATA_ADMIN_ROLE(), msg.sender);
        ppt.renounceRole(ppt.DEFAULT_ADMIN_ROLE(), msg.sender);
        vm.stopBroadcast();
    }
}
