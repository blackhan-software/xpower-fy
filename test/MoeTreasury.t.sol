// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {Constant} from "../source/contracts/libs/Constant.sol";
import {MoeTreasury} from "../source/contracts/MoeTreasury.sol";
import {TestBase as Base} from "./base/Base.mty.t.sol";
import {PoolMock} from "./mock/Pool.mock.sol";

contract TestBase is Base {
    uint256 constant mintable0 = 527973.520391_061431_395025e18;
    uint256 constant minfunny3 = 528218.016218_637971_702820e18;
    uint256 constant mintable3 = 269174.112374_429212_977327e18;
    uint256 constant mintable = mintable0 + mintable3;

    uint256 constant amount0 = 32.153840_000000_000000e18;
    uint256 constant amount3 = 34.750000_000000_000000e18;
    uint256 constant amount = amount0 + amount3;

    uint256[] mintables = [mintable0, mintable3];
    uint256[] amounts = [amount0, amount3];
    uint256[] nils = [uint(0), uint(0)];
}

contract MoeTreasuryTest_Claim is TestBase {
    function setUp() public override {
        super.setUp();
        mty.init(address(pool));
        vm.warp(52 * Constant.YEAR);
    }

    function testRewardOf() public view {
        assertEq(mty.rewardOf(self, 202100), amount0);
        assertEq(mty.rewardOf(self, 202103), amount3);
    }

    function testClaimed() public view {
        assertEq(mty.claimed(self, 202100), 0);
        assertEq(mty.claimed(self, 202103), 0);
    }

    function testMinted() public view {
        assertEq(mty.minted(self, 202100), 0);
        assertEq(mty.minted(self, 202103), 0);
    }

    function testClaimable() public view {
        assertEq(mty.claimable(self, 202100), amount0);
        assertEq(mty.claimable(self, 202103), amount3);
    }

    function testMintable() public view {
        // *good*-estimates the mintable amount: ok
        assertEq(mty.mintable(self, 202100), mintable0);
        // *over*-estimates the mintable amount: ok!
        assertEq(mty.mintable(self, 202103), minfunny3);
    }

    function testClaim() public {
        uint256 sov_amount0 = mty.mintable(self, 202100);
        assertEq(sov_amount0, mintable0);
        vm.expectEmit();
        emit MoeTreasury.Claim(self, 202100, sov_amount0);
        mty.claim(self, 202100, sov_amount0, 0);
        ///
        uint256 sov_amount3 = mty.mintable(self, 202103);
        assertEq(sov_amount3, mintable3);
        vm.expectEmit();
        emit MoeTreasury.Claim(self, 202103, sov_amount3);
        mty.claim(self, 202103, sov_amount3, 0);
        ///
        assertEq(sov.balanceOf(address(pool)), mintable);
        assertEq(sp(sov).balanceOf(self), mintable);
        assertEq(sov.totalSupply(), mintable);
        assertEq(sov.balanceOf(self), 0);
        ///
        assertEq(mty.minted(self, 202100), mintable0);
        assertEq(mty.rewardOf(self, 202100), amount0);
        assertEq(mty.claimed(self, 202100), amount0);
        assertEq(mty.claimable(self, 202100), 0);
        assertEq(mty.mintable(self, 202100), 0);
        ///
        assertEq(mty.minted(self, 202103), mintable3);
        assertEq(mty.rewardOf(self, 202103), amount3);
        assertEq(mty.claimed(self, 202103), amount3);
        assertEq(mty.claimable(self, 202103), 0);
        assertEq(mty.mintable(self, 202103), 0);
    }
}

contract MoeTreasuryTest_ClaimBatch is TestBase {
    function setUp() public override {
        super.setUp();
        mty.init(address(pool));
        vm.warp(52 * Constant.YEAR);
    }

    function testRewardOf() public view {
        assertEq(mty.rewardOfBatch(self, nft_ids), amounts);
    }

    function testClaimedBatch() public view {
        assertEq(mty.claimedBatch(self, nft_ids), nils);
    }

    function testMintedBatch() public view {
        assertEq(mty.mintedBatch(self, nft_ids), nils);
    }

    function testClaimableBatch() public view {
        assertEq(mty.claimableBatch(self, nft_ids), amounts);
    }

    function testMintableBatch() public view {
        // *good*-estimates the mintable amounts: ok
        assertEq(mty.mintableBatch(self, nft_ids), mintables);
    }

    function testClaimBatch() public {
        uint256[] memory sov_amounts = mty.mintableBatch(self, nft_ids);
        assertEq(sov_amounts, mintables);
        vm.expectEmit();
        emit MoeTreasury.ClaimBatch(self, nft_ids, sov_amounts);
        mty.claimBatch(self, nft_ids, sum(sov_amounts), 0);
        ///
        assertEq(sov.balanceOf(address(pool)), mintable);
        assertEq(sp(sov).balanceOf(self), mintable);
        assertEq(sov.totalSupply(), mintable);
        assertEq(sov.balanceOf(self), 0);
        ///
        assertEq(mty.mintedBatch(self, nft_ids), mintables);
        assertEq(mty.rewardOfBatch(self, nft_ids), amounts);
        assertEq(mty.claimedBatch(self, nft_ids), amounts);
        assertEq(mty.claimableBatch(self, nft_ids), nils);
        assertEq(mty.mintableBatch(self, nft_ids), nils);
    }

    function testClaimBatch_Predictable() public {
        uint256[] memory bef_amounts = mty.mintableBatch(self, nft_ids);
        assertEq(bef_amounts, mintables);
        vm.warp(block.timestamp + 1 minutes); // PoW delay (for example)
        uint256[] memory aft_amounts = mty.mintableBatch(self, nft_ids);
        assertGt(aft_amounts, mintables);
        ///
        vm.expectEmit();
        emit MoeTreasury.ClaimBatch(self, nft_ids, aft_amounts); // ok!
        mty.claimBatch(self, nft_ids, sum(bef_amounts), 0); // ok!
        ///
        assertEq(sov.balanceOf(address(pool)), mintable);
        assertEq(sp(sov).balanceOf(self), mintable);
        assertEq(sov.totalSupply(), mintable);
        assertEq(sov.balanceOf(self), 0);
        ///
        assertGt(mty.mintedBatch(self, nft_ids), mintables);
        assertGt(mty.rewardOfBatch(self, nft_ids), amounts);
        assertGt(mty.claimedBatch(self, nft_ids), amounts);
        assertEq(mty.claimableBatch(self, nft_ids), nils);
        assertEq(mty.mintableBatch(self, nft_ids), nils);
    }
}

contract MoeTreasuryTest_Init is TestBase {
    PoolMock mock = new PoolMock();

    function testInit() public {
        vm.expectEmit();
        emit Init(address(pool));
        mty.init(address(pool));
    }

    function testInit_oldPool() public {
        mty.init(address(pool));
        vm.expectRevert(
            abi.encodeWithSelector(AlreadyInitialized.selector, pool)
        );
        mty.init(address(pool));
    }

    function testInit_newPool() public {
        mty.init(address(pool));
        vm.expectRevert(
            abi.encodeWithSelector(AlreadyInitialized.selector, pool)
        );
        mty.init(address(mock));
    }

    function testInit_asUser() public {
        vm.prank(papa);
        vm.expectRevert(
            abi.encodeWithSelector(UNAUTHORIZED_ACCOUNT, papa, bytes32(0x0))
        );
        mty.init(address(pool));
    }

    bytes4 UNAUTHORIZED_ACCOUNT = AccessControlUnauthorizedAccount.selector;
    error AccessControlUnauthorizedAccount(address account, bytes32 role);
    error AlreadyInitialized(address pool);
    event Init(address pool);
}

contract MoeTreasuryTest_Capped_Lt is TestBase {
    function setUp() public override {
        super.setUp();
        vm.warp(51 * Constant.YEAR + 12 hours);
    }

    function testClaim_00() public {
        uint256 sov_amount0 = mty.mintable(self, 202100);
        assertEq(sov_amount0, 720.607911_392405_034466e18);
        uint256 min_amount0 = Math.min(sov_amount0, 1440e18);
        assertEq(min_amount0, 720.607911_392405_034466e18);
        mty.claim(self, 202100, min_amount0, 0);
        assertEq(sov.balanceOf(self), min_amount0);
        assertLe(sov.totalSupply(), 1440e18);
    }

    function testClaim_03() public {
        uint256 sov_amount3 = mty.mintable(self, 202103);
        assertEq(sov_amount3, 720.082807_370184_225803e18);
        uint256 min_amount3 = Math.min(sov_amount3, 1440e18);
        assertEq(min_amount3, 720.082807_370184_225803e18);
        mty.claim(self, 202103, min_amount3, 0);
        assertEq(sov.balanceOf(self), min_amount3);
        assertLe(sov.totalSupply(), 1440e18);
    }

    function testClaimBatch() public {
        uint256[] memory sov_amounts = mty.mintableBatch(self, nft_ids);
        assertEq(sov_amounts[0], 720.607911_392405_034466e18);
        assertEq(sov_amounts[1], 638.917775_399797_846151e18);
        uint256 min_amounts = Math.min(sum(sov_amounts), 1440e18);
        assertEq(min_amounts, 1359.525686_792202_880617e18);
        mty.claimBatch(self, nft_ids, min_amounts, 0);
        assertEq(sov.balanceOf(self), min_amounts);
        assertLe(sov.totalSupply(), 1440e18);
    }
}

contract MoeTreasuryTest_Capped_Eq is TestBase {
    function setUp() public override {
        super.setUp();
        vm.warp(51 * Constant.YEAR + 24 hours);
    }

    function testClaim_00() public {
        uint256 sov_amount0 = mty.mintable(self, 202100);
        assertEq(sov_amount0, 1441.110340_244550_713222e18);
        uint256 min_amount0 = Math.min(sov_amount0, 1440e18);
        assertEq(min_amount0, 1440e18);
        mty.claim(self, 202100, min_amount0, 0);
        assertEq(sov.balanceOf(self), min_amount0);
        assertEq(sov.totalSupply(), 1440e18);
    }

    function testClaim_03() public {
        uint256 sov_amount3 = mty.mintable(self, 202103);
        assertEq(sov_amount3, 1440.106765_207504_206181e18);
        uint256 min_amount3 = Math.min(sov_amount3, 1440e18);
        assertEq(min_amount3, 1440e18);
        mty.claim(self, 202103, min_amount3, 0);
        assertEq(sov.balanceOf(self), min_amount3);
        assertEq(sov.totalSupply(), 1440e18);
    }

    function testClaimBatch() public {
        uint256[] memory sov_amounts = mty.mintableBatch(self, nft_ids);
        assertEq(sov_amounts[0], 1441.110340_244550_713222e18);
        assertEq(sov_amounts[1], 1222.266731_001206_223726e18);
        uint256 min_amounts = Math.min(sum(sov_amounts), 1440e18);
        assertEq(min_amounts, 1440e18);
        mty.claimBatch(self, nft_ids, min_amounts, 0);
        assertEq(sov.balanceOf(self), min_amounts);
        assertEq(sov.totalSupply(), 1440e18);
    }
}

contract MoeTreasuryTest_Capped_Gt is TestBase {
    function setUp() public override {
        super.setUp();
        vm.warp(51 * Constant.YEAR + 24 hours);
    }

    function testClaim_00() public {
        uint256 sov_amount0 = mty.mintable(self, 202100);
        assertEq(sov_amount0, 1441.110340_244550_713222e18);
        vm.expectRevert(abi.encodeWithSelector(Capped.selector, 1440e18));
        mty.claim(self, 202100, sov_amount0, 0);
        assertEq(sov.balanceOf(self), 0);
        assertEq(sov.totalSupply(), 0);
    }

    function testClaim_03() public {
        uint256 sov_amount3 = mty.mintable(self, 202103);
        assertEq(sov_amount3, 1440.106765_207504_206181e18);
        vm.expectRevert(abi.encodeWithSelector(Capped.selector, 1440e18));
        mty.claim(self, 202103, sov_amount3, 0);
        assertEq(sov.balanceOf(self), 0);
        assertEq(sov.totalSupply(), 0);
    }

    function testClaimBatch() public {
        uint256[] memory sov_amounts = mty.mintableBatch(self, nft_ids);
        assertEq(sov_amounts[0], 1441.110340_244550_713222e18);
        assertEq(sov_amounts[1], 1222.266731_001206_223726e18);
        vm.expectRevert(abi.encodeWithSelector(Capped.selector, 1440e18));
        mty.claimBatch(self, nft_ids, sum(sov_amounts), 0);
        assertEq(sov.balanceOf(self), 0);
        assertEq(sov.totalSupply(), 0);
    }

    error Capped(uint256 free_supply);
}

contract MoeTreasuryTest_InvalidClaim is TestBase {
    function setUp() public override {
        super.setUp();
        mty.init(address(pool));
    }

    function testClaim() public {
        uint256 sov_amount0 = mty.mintable(self, 202100);
        assertEq(sov_amount0, 0);
        vm.expectRevert(abi.encodeWithSelector(InvalidClaim.selector, 202100));
        mty.claim(self, 202100, type(uint256).max, 0);
        ///
        uint256 sov_amount3 = mty.mintable(self, 202103);
        assertEq(sov_amount3, 0);
        vm.expectRevert(abi.encodeWithSelector(InvalidClaim.selector, 202103));
        mty.claim(self, 202103, type(uint256).max, 0);
    }

    function testClaimBatch() public {
        uint256[] memory sov_amounts = mty.mintableBatch(self, nft_ids);
        assertEq(sum(sov_amounts), 0);
        vm.expectRevert(abi.encodeWithSelector(InvalidClaim.selector, 202100));
        mty.claimBatch(self, nft_ids, type(uint256).max, 0);
    }

    error InvalidClaim(uint256 nft_id);
}

contract MoeTreasuryTest_InvalidAssets is TestBase {
    function setUp() public override {
        super.setUp();
        mty.init(address(pool));
        vm.warp(52 * Constant.YEAR);
    }

    function testClaim() public {
        vm.expectRevert(abi.encodeWithSelector(InvalidAssets.selector, 0));
        mty.claim(self, 202100, 0, 0);
        vm.expectRevert(abi.encodeWithSelector(InvalidAssets.selector, 0));
        mty.claim(self, 202103, 0, 0);
    }

    function testClaimBatch() public {
        vm.expectRevert(abi.encodeWithSelector(InvalidAssets.selector, 0));
        mty.claimBatch(self, nft_ids, 0, 0);
    }

    error InvalidAssets(uint256 assets);
}
