// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

import {Supervised} from "../base/Supervised.sol";

/**
 * @title APower auto-supplier (with locking).
 */
contract Banq is Supervised {
    /** underlying token to supply */
    ERC20Burnable private immutable _token;
    /** max. amount of free supply */
    uint256 private immutable _free_supply;
    /** address of lending pool */
    address public pool;

    /** @param token address of contract */
    /** @param free_supply maximum */
    constructor(address token, uint256 free_supply) {
        _token = ERC20Burnable(token);
        _free_supply = free_supply;
    }

    /** post-constructor init (once) */
    function init(address pool_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(pool == address(0), AlreadyInitialized(pool));
        pool = pool_;
        emit Init(pool_);
    }

    event Init(address pool);

    /**
     * Supply tokens to a pool (and *burning* any excess).
     *
     * @param account to supply for
     * @param amount to supply
     * @param nonce of PoW
     */
    modifier banq(
        address account,
        uint256 amount,
        uint256 nonce
    ) {
        uint256 old_balance = _token.balanceOf(account);
        _; // execute the body of the modified function
        uint256 new_balance = _token.balanceOf(account);
        if (new_balance > old_balance) {
            unchecked {
                uint256 dif_balance = new_balance - old_balance;
                uint256 min_balance = Math.min(amount, dif_balance);
                if (dif_balance > min_balance) {
                    _token.burnFrom(account, dif_balance - min_balance);
                }
                if (pool == address(0)) {
                    if (_token.totalSupply() > _free_supply) {
                        revert Capped(_free_supply);
                    }
                } else {
                    _supply(account, min_balance, nonce);
                }
            }
        }
    }

    function _supply(address account, uint256 amount, uint256 nonce) private {
        bytes memory args1 = abi.encodeWithSelector(
            0x3e6f66dc, // supply(address,address,uint256,bool)
            account, // address
            _token, // address
            amount, // supply
            true, // lock
            nonce // PoW!
        );
        (bool ok1, bytes memory data1) = pool.call(args1);
        if (!ok1) {
            if (data1.length > 0) {
                assembly {
                    revert(add(data1, 32), mload(data1))
                }
            }
            revert();
        }
        uint256 assets = abi.decode(data1, (uint256));
        require(assets > 0, InvalidAssets(assets));
    }

    /** Thrown on already initialized pool. */
    error AlreadyInitialized(address pool);
    /** Thrown on invalid assets. */
    error InvalidAssets(uint256 assets);
    /** Thrown on capped free-supply. */
    error Capped(uint256 free_supply);
}
