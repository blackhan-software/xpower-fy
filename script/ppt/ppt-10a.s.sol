// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {APowerNft} from "../../source/contracts/APowerNft.sol";
import {console} from "forge-std/console.sol";
import {BaseScript} from "../base.s.sol";

contract Run is BaseScript {
    function run() external {
        string memory pptUri = stringOf("APOW_NFT_URI");
        address[] memory pptBase = new address[](1);
        pptBase[0] = addressOf("APOW_NFT_09c");
        ///
        vm.startBroadcast();
        APowerNft ppt = new APowerNft(pptUri, pptBase, DEADLINE);
        vm.stopBroadcast();
        console_log(ppt);
    }

    function console_log(APowerNft ppt) internal pure {
        console.log("APOW_NFT_10a", address(ppt));
    }

    uint256 constant DEADLINE = 0; // *no* migration!
}
