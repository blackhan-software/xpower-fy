// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Test} from "forge-std/Test.sol";

contract Base is Test {
    function sum(uint256[] memory a) internal pure returns (uint256 total) {
        for (uint256 i = 0; i < a.length; i++) total += a[i];
    }

    function assertGt(uint256[] memory a, uint256[] memory b) internal pure {
        for (uint256 i = 0; i < a.length; i++) assertGt(a[i], b[i]);
    }

    function pad(uint n, uint lhz) internal pure returns (string memory) {
        string memory s = Strings.toString(n);
        for (uint256 j = 1; j < lhz; j++) {
            if (n < 10 ** j) {
                s = string(abi.encodePacked("0", s));
            }
        }
        return s;
    }

    function fmt(uint256 n, uint256 p) internal pure returns (string memory) {
        if (n == 0) return "0e+0";
        uint256 e = 0;
        uint256 m = n;
        // Normalize mantissa to be in range [1, 10)
        while (m >= 10) {
            m /= 10;
            e++;
        }
        // Get next digit for decimal place
        uint256 d = (n / (10 ** (e + 1 - p))) % (10 ** p);
        return
            string(
                abi.encodePacked(
                    Strings.toString(m),
                    ".",
                    Strings.toString(d),
                    "e+",
                    Strings.toString(e)
                )
            );
    }
}
