// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

import {NftBase} from "./base/NftBase.sol";
import {XPower} from "./XPower.sol";

/**
 * Class for the XPOW NFTs, where each can only be minted by depositing the
 * corresponding amount of tokens.
 */
contract XPowerNft is NftBase {
    /** burnable proof-of-work tokens */
    XPower private immutable _moe;

    /** @param moeLink address of MOE tokens */
    /** @param nftUri metadata URI */
    /** @param nftBase addresses of old contracts */
    /** @param deadlineIn seconds to end-of-migration */
    constructor(
        address moeLink,
        string memory nftUri,
        address[] memory nftBase,
        uint256 deadlineIn
    ) NftBase("XPower NFTs", "XPOWNFT", nftUri, nftBase, deadlineIn) {
        _moe = XPower(moeLink);
    }

    /** mint NFTs */
    function mint(address account, uint256 level, uint256 amount) external {
        require(
            account == msg.sender || approvedMint(account, msg.sender),
            UnauthorizedAccount(account)
        );
        _depositFrom(account, level, amount); // MOE transfer to vault
        _mint(account, idBy(year(), level), amount, "");
    }

    // slither-disable-next-line arbitrary-send-erc20
    function _depositFrom(
        address account,
        uint256 level,
        uint256 amount
    ) private {
        uint256 moeAmount = amount * denominationOf(level);
        assert(
            _moe.transferFrom(
                account,
                address(this),
                moeAmount * 10 ** _moe.decimals()
            )
        );
    }

    /** approve minting by `operator` */
    function approveMint(address operator, bool approved) external {
        require(msg.sender != operator, SelfApproving(operator));
        _mintingApprovals[msg.sender][operator] = approved;
        emit ApproveMinting(msg.sender, operator, approved);
    }

    /** @return true if `account` approved minting by `operator` */
    function approvedMint(
        address account,
        address operator
    ) public view returns (bool) {
        return _mintingApprovals[account][operator];
    }

    /** minting approvals: account => operator */
    mapping(address => mapping(address => bool)) private _mintingApprovals;

    /**
     * emitted when `account` grants or revokes permission to
     * `operator` to mint their tokens according to `approved`
     */
    event ApproveMinting(
        address indexed account,
        address indexed operator,
        bool approved
    );

    /** burn NFTs */
    function burn(address account, uint256 id, uint256 amount) public override {
        super.burn(account, id, amount);
        _redeemTo(account, id, amount);
    }

    function _redeemTo(address account, uint256 id, uint256 amount) private {
        require(_redeemable(id), IrredeemableIssue(id));
        uint256 moeAmount = amount * denominationOf(levelOf(id));
        assert(_moe.transfer(account, moeAmount * 10 ** _moe.decimals()));
    }

    function _redeemable(uint256 id) private view returns (bool) {
        return
            yearOf(id) + 2 ** (levelOf(id) / 3) - 1 <= year() || migratable();
    }

    /** burn NFTs during migration */
    function _burnFrom(
        address account,
        uint256 id,
        uint256 amount,
        uint256[] memory index
    ) internal override {
        super._burnFrom(account, id, amount, index);
        _migrateDeposit(account, id, amount, index);
    }

    // slither-disable-next-line unused-return
    function _migrateDeposit(
        address account,
        uint256 id,
        uint256 amount,
        uint256[] memory index
    ) private {
        uint256 moeAmount = amount * denominationOf(levelOf(id));
        uint256[] memory moeIndex = new uint256[](1);
        moeIndex[0] = index[1]; // drop nft-index
        uint256 oldAmount = _moe.balanceOf(account);
        _moe.migrateFrom(account, moeAmount * 10 ** _moe.decimals(), moeIndex);
        uint256 newAmount = _moe.balanceOf(account);
        if (newAmount > oldAmount) {
            uint256 migAmount = newAmount - oldAmount;
            assert(_moe.transferFrom(account, address(this), migAmount));
        }
    }

    /** batch-mint NFTs */
    function mintBatch(
        address account,
        uint256[] memory levels,
        uint256[] memory amounts
    ) external {
        require(
            account == msg.sender || approvedMint(account, msg.sender),
            UnauthorizedAccount(account)
        );
        _depositFromBatch(account, levels, amounts); // MOE transfer to vault
        _mintBatch(account, idsBy(year(), levels), amounts, "");
    }

    // slither-disable-next-line arbitrary-send-erc20
    function _depositFromBatch(
        address account,
        uint256[] memory levels,
        uint256[] memory amounts
    ) private {
        uint256 sumAmount = 0;
        for (uint256 i = 0; i < levels.length; i++) {
            sumAmount += amounts[i] * denominationOf(levels[i]);
        }
        assert(
            _moe.transferFrom(
                account,
                address(this),
                sumAmount * 10 ** _moe.decimals()
            )
        );
    }

    /** batch-burn NFTs */
    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public override {
        for (uint256 i = 0; i < ids.length; i++) {
            require(_redeemable(ids[i]), IrredeemableIssue(ids[i]));
        }
        super.burnBatch(account, ids, amounts);
        _redeemToBatch(account, ids, amounts);
    }

    function _redeemToBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts
    ) private {
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < ids.length; i++) {
            totalAmount += amounts[i] * denominationOf(levelOf(ids[i]));
        }
        assert(_moe.transfer(account, totalAmount * 10 ** _moe.decimals()));
    }

    /** upgrade NFTs */
    function upgrade(
        address account,
        uint256 anno,
        uint256 level,
        uint256 amount
    ) external {
        require(
            account == msg.sender || approvedUpgrade(account, msg.sender),
            UnauthorizedAccount(account)
        );
        require(level > 2, NonTernaryLevel(level));
        _burn(account, idBy(anno, level - 3), amount * 1000);
        _mint(account, idBy(anno, level), amount, "");
    }

    /** upgrade NFTs */
    function upgradeBatch(
        address account,
        uint256[] memory annos,
        uint256[][] memory levels,
        uint256[][] memory amounts
    ) external {
        require(
            account == msg.sender || approvedUpgrade(account, msg.sender),
            UnauthorizedAccount(account)
        );
        uint256[][] memory levelz = new uint256[][](annos.length);
        for (uint256 i = 0; i < annos.length; i++) {
            levelz[i] = new uint256[](levels[i].length);
            for (uint256 j = 0; j < levels[i].length; j++) {
                require(levels[i][j] > 2, NonTernaryLevel(levels[i][j]));
                levelz[i][j] = levels[i][j] - 3;
            }
        }
        uint256[][] memory amountz = new uint256[][](annos.length);
        for (uint256 i = 0; i < annos.length; i++) {
            amountz[i] = new uint256[](amounts[i].length);
            for (uint256 j = 0; j < amounts[i].length; j++) {
                amountz[i][j] = amounts[i][j] * 1000;
            }
        }
        for (uint256 i = 0; i < annos.length; i++) {
            _burnBatch(account, idsBy(annos[i], levelz[i]), amountz[i]);
            _mintBatch(account, idsBy(annos[i], levels[i]), amounts[i], "");
        }
    }

    /** approve upgrading by `operator` */
    function approveUpgrade(address operator, bool approved) external {
        require(msg.sender != operator, SelfApproving(operator));
        _upgradingApprovals[msg.sender][operator] = approved;
        emit ApproveUpgrading(msg.sender, operator, approved);
    }

    /** @return true if `account` approved upgrading by `operator` */
    function approvedUpgrade(
        address account,
        address operator
    ) public view returns (bool) {
        return _upgradingApprovals[account][operator];
    }

    /** upgrading approvals: account => operator */
    mapping(address => mapping(address => bool)) private _upgradingApprovals;

    /**
     * emitted when `account` grants or revokes permission to
     * `operator` to upgrade their tokens according to `approved`
     */
    event ApproveUpgrading(
        address indexed account,
        address indexed operator,
        bool approved
    );

    /** Thrown on irredeemable issue. */
    error IrredeemableIssue(uint256 nft_id);
    /** Thrown on non-ternary level. */
    error NonTernaryLevel(uint256 level);
}
