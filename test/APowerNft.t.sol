// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {ERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import {APowerNft} from "../source/contracts/APowerNft.sol";
import {Test} from "forge-std/Test.sol";

contract TestBase is Test, ERC1155Receiver {
    APowerNft ppt;

    function setUp() public virtual {
        ppt = new APowerNft("ipfs://", new address[](0), 0);
        ppt.init(address(new MoeTreasuryMock()));
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
    uint256[] ids = [uint(202100)];
    uint256[] amounts = [uint(1)];
}

contract APowerNftTest is TestBase {
    function testMint() public {
        vm.expectEmit();
        emit IERC1155.TransferSingle(self, address(0), papa, 202100, 1);
        ppt.mint(papa, 202100, 1);
    }

    function testMintBatch() public {
        vm.expectEmit();
        emit IERC1155.TransferBatch(self, address(0), papa, ids, amounts);
        ppt.mintBatch(papa, ids, amounts);
    }
}

contract APowerNftTest_AgeOf is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mint(papa, 202100, 1);
    }

    function testNftAgeOf() public view {
        assertEq(ppt.ageOf(papa, 202100), 0);
    }

    function testNftAgeOfLater() public {
        vm.warp(block.timestamp + 1 days);
        assertEq(ppt.ageOf(papa, 202100), 1 days);
    }
}

contract APowerNftTest_Shares is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mint(papa, 202100, 1);
    }

    function testNftShares() public view {
        int256[34] memory shares = ppt.shares();
        for (uint256 i = 1; i < shares.length; i++) {
            assertEq(shares[i], 0);
        }
        assertEq(shares[0], 1);
    }
}

contract APowerNftTest_Mint is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mint(papa, 202100, 1);
    }

    function testNftBalance() public view {
        assertEq(ppt.balanceOf(papa, 202100), 1);
    }
}

contract APowerNftTest_Burn is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mint(papa, 202100, 1);
        ppt.burn(papa, 202100, 1);
    }

    function testNftBalance() public view {
        assertEq(ppt.balanceOf(papa, 202100), 0);
    }
}

contract APowerNftTest_MintBatch is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mintBatch(papa, ids, amounts);
    }

    function testNftBalance() public view {
        assertEq(ppt.balanceOf(papa, 202100), 1);
    }
}

contract APowerNftTest_BurnBatch is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mintBatch(papa, ids, amounts);
        ppt.burnBatch(papa, ids, amounts);
    }

    function testNftBalance() public view {
        assertEq(ppt.balanceOf(papa, 202100), 0);
    }
}

contract APowerNftTest_TransferFrom is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mint(papa, 202100, 1);
    }

    function testTransferFrom() public {
        vm.prank(papa);
        vm.expectEmit();
        emit IERC1155.TransferSingle(papa, papa, self, 202100, 1);
        ppt.safeTransferFrom(papa, self, 202100, 1, "");
    }
}

contract APowerNftTest_BatchTransferFrom is TestBase {
    function setUp() public virtual override {
        super.setUp();
        ppt.mint(papa, 202100, 1);
    }

    function testBatchTransferFrom() public {
        vm.prank(papa);
        vm.expectEmit();
        emit IERC1155.TransferBatch(papa, papa, self, ids, amounts);
        ppt.safeBatchTransferFrom(papa, self, ids, amounts, "");
    }
}

contract MoeTreasuryMock {
    function refreshClaimed(address, uint256, uint256, uint256) external {}
}
