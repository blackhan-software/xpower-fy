// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {Constant} from "../source/contracts/libs/Constant.sol";
import {TestBase as Base} from "./base/Base.mty.t.sol";
import {console} from "forge-std/console.sol";

contract TestBase is Base {
    function setUp() public virtual override {
        super.setUp();
        mty.init(address(pool));
    }
}

contract MoeTreasuryTest_Claim is TestBase {
    function testClaim() public {
        uint256 cum_amounts = 0;
        for (uint256 i = 0; i < 10; i++) {
            vm.warp(block.timestamp + Constant.YEAR);
            uint256 sov_amount0 = mty.mintable(self, 202100);
            mty.claim(self, 202100, sov_amount0, 0);
            uint256 sov_amount3 = mty.mintable(self, 202103);
            mty.claim(self, 202103, sov_amount3, 0);
            uint256 sum_amounts = sov_amount0 + sov_amount3;
            cum_amounts += sum_amounts;
            string memory line = string(
                abi.encodePacked(
                    " ",
                    fmt(sov_amount0, 3),
                    " ",
                    fmt(sov_amount3, 3),
                    " ",
                    fmt(sum_amounts, 3),
                    " ",
                    fmt(cum_amounts, 3)
                )
            );
            console.log(pad(i, 3), line);
        }
    }
}

contract MoeTreasuryTest_ClaimBatch is TestBase {
    function testClaimBatch() public {
        uint256 cum_amounts = 0;
        for (uint256 i = 0; i < 10; i++) {
            vm.warp(block.timestamp + Constant.YEAR);
            uint256[] memory sov_amounts = mty.mintableBatch(self, nft_ids);
            mty.claimBatch(self, nft_ids, sum(sov_amounts), 0);
            uint256 sum_amounts = sum(sov_amounts);
            cum_amounts += sum_amounts;
            string memory line = string(
                abi.encodePacked(
                    " ",
                    fmt(sov_amounts[0], 3),
                    " ",
                    fmt(sov_amounts[1], 3),
                    " ",
                    fmt(sum_amounts, 3),
                    " ",
                    fmt(cum_amounts, 3)
                )
            );
            console.log(pad(i, 3), line);
        }
    }
}
