// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {ERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import {Constants} from "../source/contracts/libs/Constants.sol";
import {MoeTreasury} from "../source/contracts/MoeTreasury.sol";
import {NftTreasury} from "../source/contracts/NftTreasury.sol";
import {APowerNft} from "../source/contracts/APowerNft.sol";
import {XPowerNft} from "../source/contracts/XPowerNft.sol";
import {APower} from "../source/contracts/APower.sol";
import {XPowerMock} from "./mock/XPower.mock.sol";

import {Test} from "forge-std/Test.sol";

contract TestBase is Test, ERC1155Receiver {
    XPowerMock moe;
    APower sov;
    XPowerNft nft;
    APowerNft ppt;
    MoeTreasury mty;
    NftTreasury nty;

    function setUp() public virtual {
        vm.warp(51 * Constants.YEAR);
        ///
        moe = new XPowerMock(1e21);
        sov = new APower(address(moe), new address[](0), 0);
        nft = new XPowerNft(address(moe), "ipfs://", new address[](0), 0);
        ppt = new APowerNft("ipfs://", new address[](0), 0);
        mty = new MoeTreasury(address(moe), address(sov), address(ppt));
        nty = new NftTreasury(address(nft), address(ppt), address(mty));
        ///
        nft.setApprovalForAll(address(nty), true);
        ppt.transferOwnership(address(nty));
        ///
        moe.approve(address(nft), type(uint256).max);
        nft.mint(self, 0, 1);
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

    address immutable papa = address(0xbaba);
    address immutable self = address(this);

    uint256[] nft_ids = [202100];
    uint256[] amounts = [1];
}

contract NftTreasuryTest_Stake is TestBase {
    function testStake() public {
        vm.expectEmit();
        emit NftTreasury.Stake(self, 202100, 1);
        nty.stake(self, 202100, 1);
    }

    function testStakeBatch() public {
        vm.expectEmit();
        emit NftTreasury.StakeBatch(self, nft_ids, amounts);
        nty.stakeBatch(self, nft_ids, amounts);
    }
}

contract NftTreasuryTest_StakeApproved is TestBase {
    function testStake() public {
        vm.expectEmit();
        emit NftTreasury.ApproveStaking(self, papa, true);
        nty.approveStake(papa, true);
        assertTrue(nty.approvedStake(self, papa));
        vm.prank(papa);
        nty.stake(self, 202100, 1);
    }

    function testStakeBatch() public {
        vm.expectEmit();
        emit NftTreasury.ApproveStaking(self, papa, true);
        nty.approveStake(papa, true);
        assertTrue(nty.approvedStake(self, papa));
        vm.prank(papa);
        nty.stakeBatch(self, nft_ids, amounts);
    }
}

contract NftTreasuryTest_Unstake is TestBase {
    function setUp() public virtual override {
        super.setUp();
        nty.stake(self, 202100, 1);
    }

    function testUnstake() public {
        vm.expectEmit();
        emit NftTreasury.Unstake(self, 202100, 1);
        nty.unstake(self, 202100, 1);
    }

    function testUnstakeBatch() public {
        vm.expectEmit();
        emit NftTreasury.UnstakeBatch(self, nft_ids, amounts);
        nty.unstakeBatch(self, nft_ids, amounts);
    }
}

contract NftTreasuryTest_UnstakeApproved is TestBase {
    function setUp() public virtual override {
        super.setUp();
        nty.stake(self, 202100, 1);
    }

    function testUnstake() public {
        vm.expectEmit();
        emit NftTreasury.ApproveUnstaking(self, papa, true);
        nty.approveUnstake(papa, true);
        assertTrue(nty.approvedUnstake(self, papa));
        vm.prank(papa);
        nty.unstake(self, 202100, 1);
    }

    function testUnstakeBatch() public {
        vm.expectEmit();
        emit NftTreasury.ApproveUnstaking(self, papa, true);
        nty.approveUnstake(papa, true);
        assertTrue(nty.approvedUnstake(self, papa));
        vm.prank(papa);
        nty.unstakeBatch(self, nft_ids, amounts);
    }
}
