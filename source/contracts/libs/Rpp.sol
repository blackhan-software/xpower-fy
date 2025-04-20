// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {Constant} from "../libs/Constant.sol";

/**
 * @title Rug pull protection
 */
library Rpp {
    /** validate params: w.r.t. Polynomial.eval3 */
    function checkArray(uint256[] memory array) internal pure {
        require(array.length == 4, InvalidArrayLength(array.length));
        // eliminate possibility of division-by-zero
        require(array[1] > 0, InvalidArrayIndex(1));
        // eliminate possibility of all-zero values
        require(array[2] > 0, InvalidArrayIndex(2));
    }

    /** validate change: 0.5 <= next / last <= 2.0 or next <= unit */
    function checkValue(
        uint256 next,
        uint256 last,
        uint256 unit
    ) internal pure {
        if (next < last) {
            require(last <= 2 * next, TooSmall(next, last));
        }
        if (next > last && last > 0) {
            require(next <= 2 * last, TooLarge(next, last));
        }
        if (next > last && last == 0) {
            require(next <= unit, TooLarge(next, last));
        }
    }

    /** validate change: invocation frequency at most once per month */
    function checkStamp(uint256 next, uint256 last) internal pure {
        if (last > 0) {
            require(next > Constant.MONTH + last, TooQuick(next, last));
        }
    }

    /** Thrown on too small next vs. last. */
    error TooSmall(uint256 next, uint256 last);
    /** Thrown on too large next vs. last. */
    error TooLarge(uint256 next, uint256 last);
    /** Thrown on too quick next vs. last. */
    error TooQuick(uint256 next, uint256 last);
    /** Thrown on invalid array length. */
    error InvalidArrayLength(uint256 length);
    /** Thrown on invalid array index. */
    error InvalidArrayIndex(uint256 index);
}
