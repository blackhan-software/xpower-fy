// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {XPowerNft} from "../../source/contracts/XPowerNft.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        XPowerNft nft = XPowerNft(addressOf("XPOW_NFT_10a"));
        address boss = addressOf("BOSS_ADDRESS");
        ///
        vm.startBroadcast();
        nft.grantRole(nft.NFT_ROYAL_ADMIN_ROLE(), boss);
        nft.grantRole(nft.NFT_OPEN_ADMIN_ROLE(), boss);
        nft.grantRole(nft.NFT_SEAL_ADMIN_ROLE(), boss);
        nft.grantRole(nft.URI_DATA_ADMIN_ROLE(), boss);
        nft.grantRole(nft.DEFAULT_ADMIN_ROLE(), boss);
        vm.stopBroadcast();
        vm.startBroadcast();
        nft.renounceRole(nft.NFT_ROYAL_ADMIN_ROLE(), msg.sender);
        nft.renounceRole(nft.NFT_OPEN_ADMIN_ROLE(), msg.sender);
        nft.renounceRole(nft.NFT_SEAL_ADMIN_ROLE(), msg.sender);
        nft.renounceRole(nft.URI_DATA_ADMIN_ROLE(), msg.sender);
        nft.renounceRole(nft.DEFAULT_ADMIN_ROLE(), msg.sender);
        vm.stopBroadcast();
    }
}
