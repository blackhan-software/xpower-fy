// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolMock {
    function supply(
        address token,
        uint256 amount,
        bool lock
    ) external returns (uint256 assets) {
        assert(token != address(0) && amount >= 0 && lock == true);
        assert(IERC20(token).transferFrom(msg.sender, self, amount));
        if (sp[token] == IERC20(address(0))) {
            sp[token] = new SupplyPositionMock(token);
        }
        sp[token].mint(msg.sender, amount);
        emit Supply(token, amount, lock);
        assets = amount;
    }

    function supplyOf(address token) external view returns (address) {
        assert(sp[token] != SupplyPositionMock(address(0)));
        return address(sp[token]);
    }

    event Supply(address t, uint256 a, bool l);
    mapping(address => SupplyPositionMock) sp;
    address self = address(this);
}

contract SupplyPositionMock is ERC20 {
    constructor(address token) ERC20("Supply", "s") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
