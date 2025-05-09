// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {APower} from "../source/contracts/APower.sol";
import {XPower} from "../source/contracts/XPower.sol";
import {XPowerMock} from "./mock/XPower.mock.sol";
import {PoolMock} from "./mock/Pool.mock.sol";

import {Test, stdError} from "forge-std/Test.sol";

contract TestBase is Test, IERC20Errors {
    PoolMock pool = new PoolMock();

    address apow;
    address xpow;
    XPower moe;
    APower sov;

    function setUp() public virtual {
        moe = new XPowerMock(1e21);
        sov = new APower(address(moe), new address[](0), 0);
        xpow = address(moe);
        apow = address(sov);
    }

    function sp(IERC20 token) internal view returns (IERC20) {
        return IERC20(pool.supplyOf(address(token)));
    }

    address immutable papa = address(0xbaba);
    address immutable self = address(this);
}

contract XPowerTest_Only is TestBase {
    function setUp() public override {
        super.setUp();
        vm.warp(block.timestamp + 1);
        moe.approve(address(sov), type(uint256).max);
    }

    function testMintOnly() public {
        sov.mint(papa, 1e21);
    }
}

contract XPowerTest is TestBase {
    function testName() public view {
        assertEq(sov.name(), "APower");
    }

    function testSymbol() public view {
        assertEq(sov.symbol(), "APOW");
    }

    function testDecimals() public view {
        assertEq(sov.decimals(), 18);
    }

    function testMint1() public {
        moe.approve(address(sov), type(uint256).max);
        vm.warp(block.timestamp + 1);
        ///
        assertEq(moe.balanceOf(apow), 0e21);
        assertEq(moe.balanceOf(self), 1e21);
        assertEq(moe.balanceOf(papa), 0e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), 0e18);
        sov.mint(papa, 1e21);
        assertEq(moe.balanceOf(apow), 1e21);
        assertEq(moe.balanceOf(self), 0e21);
        assertEq(moe.balanceOf(papa), 0e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), sovs);
    }

    function testMint2() public {
        moe.approve(address(sov), type(uint256).max);
        vm.warp(block.timestamp + 1);
        ///
        assertEq(moe.balanceOf(apow), 0e21);
        assertEq(moe.balanceOf(self), 1e21);
        assertEq(moe.balanceOf(papa), 0e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), 0e18);
        sov.mint(papa, 1e21);
        sov.mint(papa, 1e21);
        assertEq(moe.balanceOf(apow), 1e21);
        assertEq(moe.balanceOf(self), 0e21);
        assertEq(moe.balanceOf(papa), 0e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), sovz);
    }

    function testBurn1() public {
        moe.approve(address(sov), type(uint256).max);
        vm.warp(block.timestamp + 1);
        ///
        assertEq(moe.balanceOf(apow), 0e21);
        assertEq(moe.balanceOf(self), 1e21);
        assertEq(moe.balanceOf(papa), 0e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), 0e18);
        sov.mint(papa, 1e21);
        vm.prank(papa);
        sov.burn(sovs);
        assertEq(moe.balanceOf(apow), 0e21);
        assertEq(moe.balanceOf(self), 0e21);
        assertEq(moe.balanceOf(papa), 1e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), 0e18);
    }

    function testBurn2() public {
        moe.approve(address(sov), type(uint256).max);
        vm.warp(block.timestamp + 1);
        ///
        assertEq(moe.balanceOf(apow), 0e21);
        assertEq(moe.balanceOf(self), 1e21);
        assertEq(moe.balanceOf(papa), 0e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), 0e18);
        sov.mint(papa, 1e21);
        sov.mint(papa, 1e21);
        vm.prank(papa);
        sov.burn(sovz);
        assertEq(moe.balanceOf(apow), 0e21);
        assertEq(moe.balanceOf(self), 0e21);
        assertEq(moe.balanceOf(papa), 1e21);
        assertEq(sov.balanceOf(self), 0e18);
        assertEq(sov.balanceOf(papa), 0e18);
    }

    function testMintFail1() public {
        vm.expectPartialRevert(ERC20InsufficientAllowance.selector);
        sov.mint(papa, 1e21);
    }

    function testMintFail2() public {
        moe.approve(address(sov), type(uint256).max);
        vm.expectRevert(stdError.divisionError);
        sov.mint(papa, 1e21);
    }

    uint256 sovs = 0.016666_666666_666666e18;
    uint256 sovz = 0.024999_999999_999999e18;
}

contract XPowerTest_Migratable is TestBase {
    XPower moe_old;
    XPower moe_new;
    APower sov_old;
    APower sov_new;

    function setUp() public override {
        /// instantiate old & new XPower contracts
        moe_old = new XPowerMock(1e21);
        address[] memory moe_base = new address[](1);
        moe_base[0] = address(moe_old);
        moe_new = new XPower(moe_base, 1 days);
        /// instantiate old & new APower contracts
        sov_old = new APower(address(moe_old), new address[](0), 0);
        address[] memory sov_base = new address[](1);
        sov_base[0] = address(sov_old);
        sov_new = new APower(address(moe_new), sov_base, 1 days);
        /// initialize with *mock* pool
        sov_new.init(address(pool));
        ///
        moe_old.approve(address(sov_old), type(uint256).max);
        vm.warp(block.timestamp + 1);
        sov_old.mint(papa, 1e21);
        ///
        vm.prank(papa);
        pool.approveSupply(address(sov_new), true);
        vm.prank(papa);
        sov_new.approve(address(pool), type(uint256).max);
    }

    function testMigrate() public {
        assertEq(sov_new.balanceOf(papa), 0e18);
        assertEq(sov_old.balanceOf(papa), sovs);
        vm.prank(papa);
        moe_old.approve(address(moe_new), type(uint256).max);
        vm.prank(papa);
        moe_new.approve(address(sov_new), type(uint256).max);
        vm.prank(papa);
        sov_old.approve(address(sov_new), type(uint256).max);
        vm.prank(papa);
        moe_new.approveMigrate(address(sov_new), true);
        vm.prank(papa);
        assertEq(sov_new.migrate(sovs, index), sovs);
        ///
        assertEq(sov_new.balanceOf(address(pool)), sovs);
        assertEq(sp(sov_new).balanceOf(papa), sovs);
        assertEq(sov_new.balanceOf(papa), 0e18);
        assertEq(sov_old.balanceOf(papa), 0e18);
        assertEq(sov_new.totalSupply(), sovs);
        assertEq(sov_old.totalSupply(), 0e18);
    }

    uint256 sovs = 0.016666_666666_666666e18;
    uint256[] index = [uint(0), uint(0)];
}
