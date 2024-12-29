// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {BaseScript} from "./base.s.sol";
import {console} from "forge-std/console.sol";
import {XPowerPpt} from "../source/contracts/XPowerPpt.sol";

contract Run is BaseScript {
    function run() external {
        ///
        string memory pptUri = stringOf("XPOW_PPT_URI");
        address[] memory pptBase = new address[](15);
        pptBase[ 0] = addressOf("XPOW_PPT_V4a");
        pptBase[ 1] = addressOf("XPOW_PPT_V5a");
        pptBase[ 2] = addressOf("XPOW_PPT_V5b");
        pptBase[ 3] = addressOf("XPOW_PPT_V5c");
        pptBase[ 4] = addressOf("XPOW_PPT_V6a");
        pptBase[ 5] = addressOf("XPOW_PPT_V6b");
        pptBase[ 6] = addressOf("XPOW_PPT_V6c");
        pptBase[ 7] = addressOf("XPOW_PPT_V7a");
        pptBase[ 8] = addressOf("XPOW_PPT_V7b");
        pptBase[ 9] = addressOf("XPOW_PPT_V7c");
        pptBase[10] = addressOf("XPOW_PPT_V8a");
        pptBase[11] = addressOf("XPOW_PPT_V8b");
        pptBase[12] = addressOf("XPOW_PPT_V8c");
        pptBase[13] = addressOf("XPOW_PPT_V9a");
        pptBase[14] = addressOf("XPOW_PPT_V9b");
        ///
        vm.startBroadcast();
        XPowerPpt ppt = new XPowerPpt(
            pptUri, pptBase, DEADLINE
        );
        vm.stopBroadcast();
        console_log(ppt);
    }

    function console_log(XPowerPpt ppt) internal pure {
        console.log("XPOW_PPT_V9c_ADDRESS", address(ppt));
    }

    uint256 constant DEADLINE = 126_230_400; // 4 years
}
