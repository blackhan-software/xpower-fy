// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

import {MoeMigratable} from "./base/Migratable.sol";
import {Constants} from "./libs/Constants.sol";

/**
 * Class for the XPOW proof-of-work tokens: It verifies, that the nonce
 * and the block-hash result in a positive amount. After a verification,
 * the corresponding amount is minted for the beneficiary (plus the MoE
 * treasury).
 */
contract XPower is ERC20Permit, ERC20Burnable, MoeMigratable, Ownable {
    /** set of nonce-hashes already minted for */
    mapping(bytes32 => bool) private _hashes;
    /** map from block-hashes to timestamps */
    mapping(bytes32 => uint256) private _timestamps;
    /** map from intervals to block-hashes */
    mapping(uint256 => bytes32) private _blockHashes;

    /** @param moeBase addresses of old contracts */
    /** @param deadlineIn seconds to end-of-migration */
    constructor(
        address[] memory moeBase,
        uint256 deadlineIn
    )
        // ERC20 constructor: name, symbol
        ERC20("XPower", "XPOW")
        // ERC20Permit constructor: name
        ERC20Permit("XPower")
        // MoeMigratable: old contract, rel. deadline [seconds]
        MoeMigratable(moeBase, deadlineIn)
    {}

    /** @return number of decimals of representation */
    function decimals() public view virtual override returns (uint8) {
        return Constants.DECIMALS;
    }

    /** emitted on caching most recent block-hash */
    event Init(bytes32 blockHash, uint256 timestamp);

    /** cache most recent block-hash */
    function init() external {
        uint256 interval = currentInterval();
        if (uint256(_blockHashes[interval]) == 0) {
            bytes32 blockHash = blockhash(block.number - 1);
            uint256 timestamp = block.timestamp;
            _blockHashes[interval] = blockHash;
            _timestamps[blockHash] = timestamp;
            emit Init(blockHash, timestamp);
        } else {
            bytes32 blockHash = _blockHashes[interval];
            uint256 timestamp = _timestamps[blockHash];
            emit Init(blockHash, timestamp);
        }
    }

    /** mint tokens for to-beneficiary, block-hash & data (incl. nonce) */
    function mint(address to, bytes32 blockHash, bytes calldata data) external {
        // check block-hash to be in current interval
        require(_recent(blockHash), "expired block-hash");
        // calculate nonce-hash & pair-index for to, block-hash & data
        (bytes32 nonceHash, bytes32 pairIndex) = _hashOf(to, blockHash, data);
        require(_unique(pairIndex), "duplicate nonce-hash");
        // calculate number of zeros of nonce-hash
        uint256 zeros = _zerosOf(nonceHash);
        require(zeros > 0, "empty nonce-hash");
        // calculate amount of tokens of zeros
        uint256 amount = _amountOf(zeros);
        // ensure unique (nonce-hash, block-hash)
        _hashes[pairIndex] = true;
        // mint for contract owner
        _mint(owner(), amount);
        // mint for beneficiary
        _mint(to, amount);
    }

    /** @return block-hash */
    function blockHashOf(uint256 interval) external view returns (bytes32) {
        return _blockHashes[interval];
    }

    /** @return current interval's timestamp */
    function currentInterval() public view returns (uint256) {
        return block.timestamp / (1 hours);
    }

    /** check whether block-hash has recently been cached */
    function _recent(bytes32 blockHash) private view returns (bool) {
        return _timestamps[blockHash] >= currentInterval() * (1 hours);
    }

    /** @return hash of contract, to-beneficiary, block-hash & data (incl. nonce) */
    function _hashOf(
        address to,
        bytes32 blockHash,
        bytes calldata data
    ) internal view returns (bytes32, bytes32) {
        bytes32 nonceHash = keccak256(
            bytes.concat(
                bytes20(uint160(address(this)) ^ uint160(to)),
                blockHash,
                data
            )
        );
        return (nonceHash, nonceHash ^ blockHash);
    }

    /** check whether (nonce-hash, block-hash) pair is unique */
    function _unique(bytes32 pairIndex) private view returns (bool) {
        return !_hashes[pairIndex];
    }

    /** @return number of leading-zeros */
    function _zerosOf(bytes32 nonceHash) internal pure returns (uint8) {
        if (nonceHash > 0) {
            return uint8(63 - (Math.log2(uint256(nonceHash)) >> 2));
        }
        return 64;
    }

    /** @return amount (for level) */
    function _amountOf(uint256 level) internal view returns (uint256) {
        return (2 ** level - 1) * 10 ** decimals();
    }

    /** @return true if this contract implements the interface defined by interface-id */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(MoeMigratable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
