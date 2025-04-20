// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import {Constant} from "../source/contracts/libs/Constant.sol";
import {XPowerNft} from "../source/contracts/XPowerNft.sol";
import {XPower} from "../source/contracts/XPower.sol";
import {XPowerMock} from "./mock/XPower.mock.sol";

import {Test} from "forge-std/Test.sol";

contract TestBase is Test {
    XPowerNft nft;
    XPower moe;

    function setUp() public virtual {
        moe = new XPowerMock(1e21);
        moe.init();
        nft = new XPowerNft(address(moe), "ipfs://", new address[](0), 0);
        vm.warp(51 * Constant.YEAR);
    }

    address immutable papa = address(0xbaba);
    address immutable self = address(this);

    uint256[] ids = [uint(202100)];
    uint256[] amounts = [uint(1)];
    uint256[] levels = [uint(0)];
}

contract XPowerNftTest is TestBase {
    function testMint() public {
        moe.transfer(papa, 1e18);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        vm.expectEmit();
        emit IERC1155.TransferSingle(papa, address(0), papa, 202100, 1);
        nft.mint(papa, 0, 1);
    }

    function testMintBatch() public {
        moe.transfer(papa, 1e18);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        vm.expectEmit();
        emit IERC1155.TransferSingle(papa, address(0), papa, 202100, 1);
        nft.mintBatch(papa, levels, amounts);
    }
}

contract XPowerNftTest_Mint is TestBase {
    function setUp() public virtual override {
        super.setUp();
        moe.transfer(papa, 1e18);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        nft.mint(papa, 0, 1);
    }

    function testNftBalance() public view {
        assertEq(nft.balanceOf(papa, 202100), 1);
    }

    function testMoeBalance() public view {
        assertEq(moe.balanceOf(address(nft)), 1e18);
        assertEq(moe.balanceOf(papa), 0);
    }
}

contract XPowerNftTest_Burn is TestBase {
    function setUp() public virtual override {
        super.setUp();
        moe.transfer(papa, 1e18);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        nft.mint(papa, 0, 1);
        vm.prank(papa);
        nft.burn(papa, 202100, 1);
    }

    function testNftBalance() public view {
        assertEq(nft.balanceOf(papa, 202100), 0);
    }

    function testMoeBalance() public view {
        assertEq(moe.balanceOf(address(nft)), 0);
        assertEq(moe.balanceOf(papa), 1e18);
    }
}

contract XPowerNftTest_MintBatch is TestBase {
    function setUp() public virtual override {
        super.setUp();
        moe.transfer(papa, 1e18);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        nft.mintBatch(papa, levels, amounts);
    }

    function testNftBalance() public view {
        assertEq(nft.balanceOf(papa, 202100), 1);
    }

    function testMoeBalance() public view {
        assertEq(moe.balanceOf(address(nft)), 1e18);
        assertEq(moe.balanceOf(papa), 0);
    }
}

contract XPowerNftTest_BurnBatch is TestBase {
    function setUp() public virtual override {
        super.setUp();
        moe.transfer(papa, 1e18);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        nft.mintBatch(papa, levels, amounts);
        vm.prank(papa);
        nft.burnBatch(papa, ids, amounts);
    }

    function testNftBalance() public view {
        assertEq(nft.balanceOf(papa, 202100), 0);
    }

    function testMoeBalance() public view {
        assertEq(moe.balanceOf(address(nft)), 0);
        assertEq(moe.balanceOf(papa), 1e18);
    }
}

contract XPowerNftTest_Upgrade is TestBase {
    function setUp() public virtual override {
        super.setUp();
        moe.transfer(papa, 1e21);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        nft.mint(papa, 0, 1e3);
        vm.prank(papa);
        nft.upgrade(papa, 2021, 3, 1);
    }

    function testNftBalance() public view {
        assertEq(nft.balanceOf(papa, 202100), 0);
        assertEq(nft.balanceOf(papa, 202103), 1);
    }

    function testMoeBalance() public view {
        assertEq(moe.balanceOf(address(nft)), 1e21);
        assertEq(moe.balanceOf(papa), 0);
    }
}

contract XPowerNftTest_UpgradeBatch is TestBase {
    function setUp() public virtual override {
        super.setUp();
        moe.transfer(papa, 1e21);
        vm.prank(papa);
        moe.approve(address(nft), type(uint256).max);
        vm.prank(papa);
        nft.mint(papa, 0, 1e3);
        vm.prank(papa);
        nft.upgradeBatch(papa, annoz, levelz, amountz);
    }

    function testNftBalance() public view {
        assertEq(nft.balanceOf(papa, 202100), 0);
        assertEq(nft.balanceOf(papa, 202103), 1);
    }

    function testMoeBalance() public view {
        assertEq(moe.balanceOf(address(nft)), 1e21);
        assertEq(moe.balanceOf(papa), 0);
    }

    uint256[][] amountz = [[uint(1)]];
    uint256[][] levelz = [[uint(3)]];
    uint256[] annoz = [uint(2021)];
}

contract XPowerNft_Migratable is TestBase {
    XPowerNft nft_old;
    XPowerNft nft_new;
    XPower moe_old;
    XPower moe_new;

    function setUp() public virtual override {
        vm.warp(51 * Constant.YEAR);
        ///
        moe_old = new XPowerMock(1e21);
        moe_old.init();
        address[] memory moe_base = new address[](1);
        moe_base[0] = address(moe_old);
        moe_new = new XPower(moe_base, 0);
        moe_new.init();
        ///
        nft_old = new XPowerNft(
            address(moe_old),
            "ipfs://",
            new address[](0),
            0
        );
        address[] memory nft_base = new address[](1);
        nft_base[0] = address(nft_old);
        nft_new = new XPowerNft(address(moe_new), "ipfs://", nft_base, 0);
        moe_old.transfer(papa, 1e18);
        vm.prank(papa);
        moe_old.approve(address(nft_old), type(uint256).max);
        vm.prank(papa);
        nft_old.mint(papa, 0, 1);
    }

    function testMigrate() public {
        vm.prank(papa);
        moe_old.approve(address(moe_new), type(uint256).max);
        vm.prank(papa);
        moe_new.approve(address(nft_new), type(uint256).max);
        vm.prank(papa);
        nft_old.setApprovalForAll(address(nft_new), true);
        vm.prank(papa);
        moe_new.approveMigrate(address(nft_new), true);
        vm.prank(papa);
        nft_new.migrateFrom(papa, 202100, 1, index);
        ///
        assertEq(moe_new.balanceOf(address(nft_new)), 1e18);
        assertEq(moe_old.balanceOf(address(nft_old)), 0);
        assertEq(nft_new.balanceOf(papa, 202100), 1);
        assertEq(nft_old.balanceOf(papa, 202100), 0);
    }

    uint256[] index = [uint(0), uint(0)];
}

contract XPowerNft_MigratableBatch is TestBase {
    XPowerNft nft_old;
    XPowerNft nft_new;
    XPower moe_old;
    XPower moe_new;

    function setUp() public virtual override {
        vm.warp(51 * Constant.YEAR);
        ///
        moe_old = new XPowerMock(1e21);
        moe_old.init();
        address[] memory moe_base = new address[](1);
        moe_base[0] = address(moe_old);
        moe_new = new XPower(moe_base, 0);
        moe_new.init();
        ///
        nft_old = new XPowerNft(
            address(moe_old),
            "ipfs://",
            new address[](0),
            0
        );
        address[] memory nft_base = new address[](1);
        nft_base[0] = address(nft_old);
        nft_new = new XPowerNft(address(moe_new), "ipfs://", nft_base, 0);
        moe_old.transfer(papa, 1e18);
        vm.prank(papa);
        moe_old.approve(address(nft_old), type(uint256).max);
        vm.prank(papa);
        nft_old.mint(papa, 0, 1);
    }

    function testMigrateBatch() public {
        vm.prank(papa);
        moe_old.approve(address(moe_new), type(uint256).max);
        vm.prank(papa);
        moe_new.approve(address(nft_new), type(uint256).max);
        vm.prank(papa);
        nft_old.setApprovalForAll(address(nft_new), true);
        vm.prank(papa);
        moe_new.approveMigrate(address(nft_new), true);
        vm.prank(papa);
        nft_new.migrateFromBatch(papa, idz, amountz, index);
        ///
        assertEq(moe_new.balanceOf(address(nft_new)), 1e18);
        assertEq(moe_old.balanceOf(address(nft_old)), 0);
        assertEq(nft_new.balanceOf(papa, 202100), 1);
        assertEq(nft_old.balanceOf(papa, 202100), 0);
    }

    uint256[] index = [uint(0), uint(0)];
    uint256[] amountz = [uint256(1)];
    uint256[] idz = [uint(202100)];
}
