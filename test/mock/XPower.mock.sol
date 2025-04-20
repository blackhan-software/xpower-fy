// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {XPower} from "../../source/contracts/XPower.sol";

contract XPowerMock is XPower {
    constructor(uint256 supply) XPower(new address[](0), 0) {
        _mint(msg.sender, supply);
    }
}
