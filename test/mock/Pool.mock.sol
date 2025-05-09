// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {IAccessManaged} from "@openzeppelin/contracts/access/manager/AccessManaged.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolMock {
    function supply(
        address user,
        address token,
        uint256 amount,
        bool lock
    ) external returns (uint256 assets) {
        assert(user != address(0));
        assert(token != address(0));
        assert(amount >= 0 && lock == true);
        assert(IERC20(token).transferFrom(user, self, amount));
        require(
            user == msg.sender ||
                approvedSupply(user, msg.sender, IERC20(token)),
            IAccessManaged.AccessManagedUnauthorized(msg.sender)
        );
        if (sp[token] == IERC20(address(0))) {
            sp[token] = new SupplyPositionMock(token);
        }
        sp[token].mint(user, amount);
        emit Supply(token, amount, lock);
        assets = amount;
    }

    function supplyOf(address token) external view returns (address) {
        assert(sp[token] != SupplyPositionMock(address(0)));
        return address(sp[token]);
    }

    function approveSupply(
        address operator,
        IERC20 token,
        bool approved
    ) external {
        require(msg.sender != operator, SelfApproving(operator));
        _supplyApprovals[msg.sender][operator][token] = approved;
        emit ApproveSupply(msg.sender, operator, token, approved);
    }

    function approvedSupply(
        address user,
        address operator,
        IERC20 token
    ) public view returns (bool) {
        return _supplyApprovals[user][operator][token];
    }

    mapping(address => mapping(address => mapping(IERC20 => bool)))
        private _supplyApprovals;
    event ApproveSupply(
        address indexed account,
        address indexed operator,
        IERC20 indexed token,
        bool approved
    );
    event Supply(address t, uint256 a, bool l);
    mapping(address => SupplyPositionMock) sp;
    error SelfApproving(address operator);
    address self = address(this);
}

contract SupplyPositionMock is ERC20 {
    constructor(address token) ERC20("Supply", "s") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
