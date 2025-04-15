// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

abstract contract BaseScript is Script {
    function addressOf(string memory key) internal view returns (address) {
        address value = vm.envAddress(key);
        assert(value != address(0));
        return value;
    }

    function stringOf(string memory key) internal view returns (string memory) {
        string memory value = vm.envString(key);
        assert(bytes(value).length > 0);
        return value;
    }
}
