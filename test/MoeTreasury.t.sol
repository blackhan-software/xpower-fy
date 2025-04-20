// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {ERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Constants} from "../source/contracts/libs/Constants.sol";
import {MoeTreasury} from "../source/contracts/MoeTreasury.sol";
import {NftTreasury} from "../source/contracts/NftTreasury.sol";
import {APowerNft} from "../source/contracts/APowerNft.sol";
import {XPowerNft} from "../source/contracts/XPowerNft.sol";
import {APower} from "../source/contracts/APower.sol";
import {XPowerMock} from "./mock/XPower.mock.sol";
import {PoolMock} from "./mock/Pool.mock.sol";

import {Test} from "forge-std/Test.sol";

contract TestBase is Test, ERC1155Receiver {
    PoolMock pool = new PoolMock();

    XPowerMock moe;
    APower sov;
    XPowerNft nft;
    APowerNft ppt;
    MoeTreasury mty;
    NftTreasury nty;

    function setUp() public virtual {
        vm.warp(51 * Constants.YEAR);
        ///
        moe = new XPowerMock(1e18 + 1e21);
        sov = new APower(address(moe), new address[](0), 0);
        nft = new XPowerNft(address(moe), "ipfs://", new address[](0), 0);
        ppt = new APowerNft("ipfs://", new address[](0), 0);
        mty = new MoeTreasury(address(moe), address(sov), address(ppt));
        nty = new NftTreasury(address(nft), address(ppt), address(mty));
        ///
        nft.setApprovalForAll(address(nty), true);
        ppt.transferOwnership(address(nty));
        sov.transferOwnership(address(mty));
        mty.init(address(pool));
        ///
        moe.approve(address(nft), type(uint256).max);
        nft.mint(self, 0, 1);
        nty.stake(self, 202100, 1);
        nft.mint(self, 3, 1);
        nty.stake(self, 202103, 1);
        ///
        vm.warp(52 * Constants.YEAR);
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return 0xf23a6e61;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override returns (bytes4) {
        return 0xbc197c81;
    }

    function sp(IERC20 token) internal view returns (IERC20) {
        return IERC20(pool.supplyOf(address(token)));
    }

    address immutable papa = address(0xbaba);
    address immutable self = address(this);

    uint256 constant mintable0 = 526514.745999_999978_939410e18;
    uint256 constant minfunny3 = 529043.960265_700461_930029e18;
    uint256 constant mintable3 = 277597.211089_987314_624882e18;
    uint256 constant mintable = mintable0 + mintable3;

    uint256 constant amount0 = 15.593500_000000_000000e18;
    uint256 constant amount3 = 19.188640_000000_000000e18;
    uint256 constant amount = amount0 + amount3;

    uint256[] mintables = [mintable0, mintable3];
    uint256[] amounts = [amount0, amount3];
    uint256[] nft_ids = [202100, 202103];
    uint256[] nils = [uint(0), uint(0)];
}

contract MoeTreasuryTest_Claim is TestBase {
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

    function sum(uint256[] memory a) private pure returns (uint256 total) {
        for (uint256 i = 0; i < a.length; i++) total += a[i];
    }

    function assertGt(uint256[] memory a, uint256[] memory b) private pure {
        for (uint256 i = 0; i < a.length; i++) assertGt(a[i], b[i]);
    }
}
