// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

/**
 * @title APower auto-supplier (with locking).
 */
contract Banq {
    /** underlying token to supply */
    ERC20Burnable private immutable _token;
    /** address of lending pool */
    address private _pool;

    /** @param token address of contract */
    constructor(address token) {
        _token = ERC20Burnable(token);
    }

    /** post-constructor init (once) */
    function init(address pool) external {
        require(_pool == address(0), "already initialized");
        _pool = pool;
        emit Init(pool);
    }

    event Init(address pool);

    /**
     * Used to supply tokens to a pool and burn any excess tokens.
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
        uint256 old_balance = _token.balanceOf(address(this));
        _; // execute the body of the modified function
        uint256 new_balance = _token.balanceOf(address(this));
        if (_pool != address(0) && new_balance > old_balance) {
            unchecked {
                uint256 dif_balance = new_balance - old_balance;
                uint256 min_balance = Math.min(amount, dif_balance);
                if (dif_balance > min_balance) {
                    _token.burn(dif_balance - min_balance);
                }
                _supply(account, min_balance, nonce);
            }
        }
    }

    function _supply(address account, uint256 amount, uint256 nonce) private {
        assert(_token.increaseAllowance(_pool, amount));
        //
        // Supply tokens to pool (for s-tokens):
        //
        bytes memory args1 = abi.encodeWithSelector(
            0x7cf51195, // supply(address,uint256,bool)
            _token, // address
            amount, // supply
            true, // lock
            nonce // PoW!
        );
        (bool ok1, bytes memory data1) = _pool.call(args1);
        if (!ok1) {
            if (data1.length > 0) {
                assembly {
                    revert(add(data1, 32), mload(data1))
                }
            }
            revert();
        }
        uint256 assets = abi.decode(data1, (uint256));
        require(assets > 0, "invalid assets");
        //
        // Transfer received s-tokens to account:
        //
        bytes memory args2 = abi.encodeWithSelector(
            0x62400e4c, // supplyOf(address)
            _token // address
        );
        (bool ok2, bytes memory data2) = _pool.call(args2);
        if (!ok2) {
            if (data2.length > 0) {
                assembly {
                    revert(add(data2, 32), mload(data2))
                }
            }
            revert();
        }
        IERC20 supply = IERC20(abi.decode(data2, (address)));
        assert(supply.transfer(account, assets));
    }
}
