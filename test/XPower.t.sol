// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {XPower} from "../source/contracts/XPower.sol";
import {XPowerMock} from "./mock/XPower.mock.sol";
import {Test} from "forge-std/Test.sol";

contract TestBase is Test {
    XPower moe;

    function setUp() public virtual {
        moe = new XPower(new address[](0), 0);
        moe.init();
    }

    address immutable papa = address(0xbaba);
    address immutable self = address(this);
    bytes constant nonce = bytes("0x0006");
}

contract XPowerTest_Only is TestBase {
    function setUp() public override {
        super.setUp();
        _blockHash = moe.blockHashOf(0);
    }

    function testMintOnly() public {
        moe.mint(papa, _blockHash, nonce);
    }

    bytes32 private _blockHash;
}

contract XPowerTest is TestBase {
    function testName() public view {
        assertEq(moe.name(), "XPower");
    }

    function testSymbol() public view {
        assertEq(moe.symbol(), "XPOW");
    }

    function testDecimals() public view {
        assertEq(moe.decimals(), 18);
    }

    function testBlockHash() public view {
        assertTrue(moe.blockHashOf(0) != bytes32(0));
    }

    function testCurrentInterval() public view {
        assertTrue(moe.currentInterval() == 0);
    }

    function testMint() public {
        moe.mint(papa, moe.blockHashOf(0), nonce);
        assertEq(moe.balanceOf(papa), 1e18);
        assertEq(moe.balanceOf(self), 1e18);
        assertEq(moe.totalSupply(), 2e18);
    }

    function testBurn() public {
        moe.mint(papa, moe.blockHashOf(0), nonce);
        vm.prank(papa);
        moe.burn(1e18);
        assertEq(moe.balanceOf(papa), 0e18);
        assertEq(moe.balanceOf(self), 1e18);
        assertEq(moe.totalSupply(), 1e18);
    }

    function testMintFail1() public {
        bytes32 blockHash = moe.blockHashOf(0);
        vm.warp(block.timestamp + 1 hours);
        vm.expectPartialRevert(XPower.ExpiredBlockHash.selector);
        moe.mint(papa, blockHash, nonce);
    }

    function testMintFail2() public {
        bytes32 blockHash = moe.blockHashOf(0);
        moe.mint(papa, blockHash, nonce);
        vm.expectPartialRevert(XPower.DuplicatePairIndex.selector);
        moe.mint(papa, blockHash, nonce);
    }

    function testMintFail3() public {
        bytes32 blockHash = moe.blockHashOf(0);
        vm.expectPartialRevert(XPower.EmptyNonceHash.selector);
        moe.mint(papa, blockHash, bytes("0x0000"));
        assertEq(moe.balanceOf(papa), 0);
    }
}

contract XPowerTest_Migratable is TestBase {
    XPower private moe_old;
    XPower private moe_new;

    function setUp() public override {
        /// instantiate old & new XPower contracts
        moe_old = new XPowerMock(1e21);
        address[] memory moe_base = new address[](1);
        moe_base[0] = address(moe_old);
        moe_new = new XPower(moe_base, 0);
        ///
        moe_old.transfer(papa, 1e18);
    }

    function testMigrate() public {
        assertEq(moe_new.balanceOf(papa), 0e18);
        assertEq(moe_old.balanceOf(papa), 1e18);
        vm.prank(papa);
        assertTrue(moe_old.approve(address(moe_new), 1e18));
        vm.prank(papa);
        assertEq(moe_new.migrate(1e18, index), 1e18);
        ///
        assertEq(moe_new.balanceOf(papa), 1e18);
        assertEq(moe_old.balanceOf(papa), 0e18);
        assertEq(moe_new.totalSupply(), 1e18);
        assertLt(moe_old.totalSupply(), 1e21);
    }

    uint256[] private index = [uint(0)];
}
