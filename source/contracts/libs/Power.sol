// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {UD60x18, ud, pow} from "@prb/math/src/UD60x18.sol";

library Power {
    /**
     * @return n raised to the power of (exp/[root=256])
     */
    function raise(uint256 n, uint256 exp) internal pure returns (uint256) {
        require(exp >= 128, InvalidExponentTooSmall(exp));
        require(exp <= 512, InvalidExponentTooLarge(exp));
        UD60x18 p = pow(ud(n * 1e18), ud(exp * 3906250e9));
        return p.intoUint256() / 1e18;
    }

    /** Thrown on invalid exponent too small. */
    error InvalidExponentTooSmall(uint256 exponent);
    /** Thrown on invalid exponent too large. */
    error InvalidExponentTooLarge(uint256 exponent);
}
