// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Constant} from "../../source/contracts/libs/Constant.sol";
import {MoeTreasury} from "../../source/contracts/MoeTreasury.sol";
import {NftTreasury} from "../../source/contracts/NftTreasury.sol";
import {APowerNft} from "../../source/contracts/APowerNft.sol";
import {XPowerNft} from "../../source/contracts/XPowerNft.sol";
import {APower} from "../../source/contracts/APower.sol";

import {XPowerMock} from "../mock/XPower.mock.sol";
import {PoolMock} from "../mock/Pool.mock.sol";
import {Base} from "./Base.t.sol";

contract TestBase is Base, IERC1155Receiver {
    PoolMock pool = new PoolMock();

    XPowerMock moe;
    APower sov;
    XPowerNft nft;
    APowerNft ppt;
    MoeTreasury mty;
    NftTreasury nty;

    function setUp() public virtual {
        vm.warp(51 * Constant.YEAR);
        ///
        moe = new XPowerMock(type(uint256).max);
        sov = new APower(address(moe), new address[](0), 0);
        nft = new XPowerNft(address(moe), "ipfs://", new address[](0), 0);
        ppt = new APowerNft("ipfs://", new address[](0), 0);
        mty = new MoeTreasury(address(moe), address(sov), address(ppt));
        nty = new NftTreasury(address(nft), address(ppt), address(mty));
        ///
        nft.setApprovalForAll(address(nty), true);
        ppt.transferOwnership(address(nty));
        sov.transferOwnership(address(mty));
        ///
        moe.approve(address(nft), type(uint256).max);
        nft_accumulate();
    }

    function nft_accumulate() internal {
        nft.mint(self, 0, 1e3); // 1e3 * unit
        nty.stake(self, 202100, 1e3);
        nft.mint(self, 3, 1e0); // 1e0 * kilo
        nty.stake(self, 202103, 1e0);
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

    function supportsInterface(
        bytes4 interfaceId
    ) external pure override returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId;
    }

    function sp(IERC20 token) internal view returns (IERC20) {
        return IERC20(pool.supplyOf(address(token)));
    }

    address immutable papa = address(0xbaba);
    address immutable self = address(this);
    uint256[] nft_ids = [202100, 202103];
}
