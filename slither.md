# Slither Report

```sh
slither . \
    --exclude=naming-conventions \
    --filter-paths=node_modules \
    --show-ignored-findings \
    --checklist > slither.md
```

## Summary

- [arbitrary-send-erc20](#arbitrary-send-erc20) (4 results) (High)
- [reentrancy-no-eth](#reentrancy-no-eth) (3 results) (Medium)
- [unused-return](#unused-return) (1 results) (Medium)
- [missing-zero-check](#missing-zero-check) (1 results) (Low)
- [calls-loop](#calls-loop) (67 results) (Low)
- [reentrancy-benign](#reentrancy-benign) (5 results) (Low)
- [reentrancy-events](#reentrancy-events) (4 results) (Low)
- [timestamp](#timestamp) (10 results) (Low)
- [assembly](#assembly) (1 results) (Informational)
- [low-level-calls](#low-level-calls) (1 results) (Informational)

## arbitrary-send-erc20

Impact: High Confidence: High

- [ ] ID-0
      [XPowerNft._depositFromBatch(address,uint256[],uint256[])](source/contracts/XPowerNft.sol#L144-L160)
      uses arbitrary from in transferFrom:
      [assert(bool)(_moe.transferFrom(account,address(this),sumAmount * 10 ** _moe.decimals()))](source/contracts/XPowerNft.sol#L153-L159)

source/contracts/XPowerNft.sol#L144-L160

- [ ] ID-1
      [SovMigratable._migrateFrom(address,uint256,uint256[])](source/contracts/base/Migratable.sol#L287-L310)
      uses arbitrary from in transferFrom:
      [assert(bool)(_moeMigratable.transferFrom(account,address(this),mig_moe))](source/contracts/base/Migratable.sol#L307)

source/contracts/base/Migratable.sol#L287-L310

- [ ] ID-2 [APower.mint(address,uint256)](source/contracts/APower.sol#L54-L64)
      uses arbitrary from in transferFrom:
      [assert(bool)(_moe.transferFrom(owner(),address(this),wrappable(claim)))](source/contracts/APower.sol#L59)

source/contracts/APower.sol#L54-L64

- [ ] ID-3
      [XPowerNft._depositFrom(address,uint256,uint256)](source/contracts/XPowerNft.sol#L39-L52)
      uses arbitrary from in transferFrom:
      [assert(bool)(_moe.transferFrom(account,address(this),moeAmount * 10 ** _moe.decimals()))](source/contracts/XPowerNft.sol#L45-L51)

source/contracts/XPowerNft.sol#L39-L52

## reentrancy-no-eth

Impact: Medium Confidence: Medium

- [ ] ID-4 Reentrancy in
      [APowerNft.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)](source/contracts/APowerNft.sol#L57-L67):
      External calls:
  - [_pushBurnBatch(account,nftIds,amounts)](source/contracts/APowerNft.sol#L64)
    - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L158-L163)
      State variables written after the call(s):
  - [_pushMintBatch(to,nftIds,amounts)](source/contracts/APowerNft.sol#L65)
    - [_age[account][nftId] += amount * block.timestamp](source/contracts/APowerNft.sol#L133)
      [APowerNft._age](source/contracts/APowerNft.sol#L16) can be used in cross
      function reentrancies:
  - [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L169)
  - [APowerNft._pushMint(address,uint256,uint256)](source/contracts/APowerNft.sol#L132-L134)
  - [APowerNft.ageOf(address,uint256)](source/contracts/APowerNft.sol#L114-L124)

source/contracts/APowerNft.sol#L57-L67

- [ ] ID-5 Reentrancy in
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L140-L158):
      External calls:
  - [assert(bool)(_moe.approve(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L152)
  - [sov_minted[i] = _sov.mint(address(this),moe_amount[i])](source/contracts/MoeTreasury.sol#L153)
  - [banq(account,amount,nonce)](source/contracts/MoeTreasury.sol#L145)
    - [assert(bool)(_token.approve(_pool,amount))](source/contracts/libs/Banq.sol#L72)
    - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L83)
    - [_token.burn(dif_balance - min_balance)](source/contracts/libs/Banq.sol#L57)
    - [assert(bool)(_token.transfer(account,min_balance))](source/contracts/libs/Banq.sol#L60)
    - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L101)
    - [assert(bool)(supply.transfer(account,assets))](source/contracts/libs/Banq.sol#L111)
      State variables written after the call(s):
  - [_claimed[account][nftIds[i]] += moe_amount[i]](source/contracts/MoeTreasury.sol#L150)
    [MoeTreasury._claimed](source/contracts/MoeTreasury.sol#L42) can be used in
    cross function reentrancies:
  - [MoeTreasury.claimed(address,uint256)](source/contracts/MoeTreasury.sol#L161-L166)
  - [MoeTreasury.refreshClaimed(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L66-L77)
  - [_minted[account][nftIds[i]] += sov_minted[i]](source/contracts/MoeTreasury.sol#L155)
    [MoeTreasury._minted](source/contracts/MoeTreasury.sol#L44) can be used in
    cross function reentrancies:
  - [MoeTreasury.minted(address,uint256)](source/contracts/MoeTreasury.sol#L80-L85)

source/contracts/MoeTreasury.sol#L140-L158

- [ ] ID-6 Reentrancy in
      [APowerNft.safeTransferFrom(address,address,uint256,uint256,bytes)](source/contracts/APowerNft.sol#L43-L53):
      External calls:
  - [_pushBurn(account,nftId,amount)](source/contracts/APowerNft.sol#L50)
    - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L158-L163)
      State variables written after the call(s):
  - [_pushMint(to,nftId,amount)](source/contracts/APowerNft.sol#L51)
    - [_age[account][nftId] += amount * block.timestamp](source/contracts/APowerNft.sol#L133)
      [APowerNft._age](source/contracts/APowerNft.sol#L16) can be used in cross
      function reentrancies:
  - [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L169)
  - [APowerNft._pushMint(address,uint256,uint256)](source/contracts/APowerNft.sol#L132-L134)
  - [APowerNft.ageOf(address,uint256)](source/contracts/APowerNft.sol#L114-L124)

source/contracts/APowerNft.sol#L43-L53

## unused-return

Impact: Medium Confidence: Medium

- [ ] ID-7
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      ignores return value by
      [_moe.migrateFrom(account,moeAmount * 10 ** _moe.decimals(),moeIndex)](source/contracts/XPowerNft.sol#L121)

source/contracts/XPowerNft.sol#L111-L127

## missing-zero-check

Impact: Low Confidence: Medium

- [ ] ID-8 [Banq.init(address).pool](source/contracts/libs/Banq.sol#L29) lacks a
      zero-check on : - [_pool = pool](source/contracts/libs/Banq.sol#L31)

source/contracts/libs/Banq.sol#L29

## calls-loop

Impact: Low Confidence: Medium

- [ ] ID-9
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-10
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L524-L526)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L525) Calls stack
      containing the loop: MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L524-L526

- [ ] ID-11
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L462)
      Calls stack containing the loop:
      MoeTreasury.setAPBBatch(uint256[],uint256[])
      MoeTreasury.setAPB(uint256,uint256[])

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-12
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L426-L428)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L427)
      Calls stack containing the loop: MoeTreasury.refreshRates(bool)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L426-L428

- [ ] ID-13
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L524-L526)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L525) Calls stack
      containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L524-L526

- [ ] ID-14
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-15
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L216)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-16
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L426-L428)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L427)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L426-L428

- [ ] ID-17
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L461) Calls stack
      containing the loop: MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-18
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [newAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L122)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-19
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L524-L526)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L525) Calls stack
      containing the loop: MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L524-L526

- [ ] ID-20
      [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L169)
      has external calls inside a loop:
      [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L158-L163)
      Calls stack containing the loop:
      APowerNft.burnBatch(address,uint256[],uint256[])
      APowerNft._memoBurnBatch(address,uint256[],uint256[])
      APowerNft._memoBurn(address,uint256,uint256)

source/contracts/APowerNft.sol#L152-L169

- [ ] ID-21
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L260-L267)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L264)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L260-L267

- [ ] ID-22
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L217)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-23
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L214)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-24
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [assert(bool)(_moe.transferFrom(account,address(this),migAmount))](source/contracts/XPowerNft.sol#L125)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-25
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L214)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-26
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L140-L158)
      has external calls inside a loop:
      [moe_wrap = _sov.wrappable(moe_amount[i])](source/contracts/MoeTreasury.sol#L151)

source/contracts/MoeTreasury.sol#L140-L158

- [ ] ID-27
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [newAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L122)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-28
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L461) Calls stack
      containing the loop: MoeTreasury.setAPBBatch(uint256[],uint256[])
      MoeTreasury.setAPB(uint256,uint256[])

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-29
      [MoeTreasury.refreshable()](source/contracts/MoeTreasury.sol#L368-L397)
      has external calls inside a loop:
      [id = _ppt.idBy(2021,3 * i)](source/contracts/MoeTreasury.sol#L372)

source/contracts/MoeTreasury.sol#L368-L397

- [ ] ID-30
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-31
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L216)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-32
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L461) Calls stack
      containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-33
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L462)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-34
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L462)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-35
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L260-L267)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L264)
      Calls stack containing the loop: MoeTreasury.refreshRates(bool)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L260-L267

- [ ] ID-36
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L216)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-37
      [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L169)
      has external calls inside a loop:
      [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L158-L163)
      Calls stack containing the loop:
      APowerNft.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)
      APowerNft._pushBurnBatch(address,uint256[],uint256[])

source/contracts/APowerNft.sol#L152-L169

- [ ] ID-38
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [_moe.migrateFrom(account,moeAmount * 10 ** _moe.decimals(),moeIndex)](source/contracts/XPowerNft.sol#L121)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-39
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L462)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-40
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L426-L428)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L427)
      Calls stack containing the loop:
      MoeTreasury.setAPRBatch(uint256[],uint256[])
      MoeTreasury.setAPR(uint256,uint256[])

source/contracts/MoeTreasury.sol#L426-L428

- [ ] ID-41
      [MoeTreasury.refreshRates(bool)](source/contracts/MoeTreasury.sol#L334-L365)
      has external calls inside a loop:
      [id = _ppt.idBy(2021,3 * i)](source/contracts/MoeTreasury.sol#L339)

source/contracts/MoeTreasury.sol#L334-L365

- [ ] ID-42
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [oldAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L120)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-43
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-44
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L524-L526)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L525) Calls stack
      containing the loop: MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L524-L526

- [ ] ID-45
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-46
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-47 [APower.decimals()](source/contracts/APower.sol#L49-L51) has
      external calls inside a loop:
      [_moe.decimals()](source/contracts/APower.sol#L50) Calls stack containing
      the loop: APower.mintableBatch(uint256[])
      APower._mintable(uint256,uint256,uint256)

source/contracts/APower.sol#L49-L51

- [ ] ID-48
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [_moe.migrateFrom(account,moeAmount * 10 ** _moe.decimals(),moeIndex)](source/contracts/XPowerNft.sol#L121)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-49
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L214)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-50
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L426-L428)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L427)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L426-L428

- [ ] ID-51
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-52
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-53
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [assert(bool)(_moe.transferFrom(account,address(this),migAmount))](source/contracts/XPowerNft.sol#L125)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-54
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L426-L428)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L427)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L426-L428

- [ ] ID-55
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L216)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-56
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L140-L158)
      has external calls inside a loop:
      [assert(bool)(_moe.approve(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L152)

source/contracts/MoeTreasury.sol#L140-L158

- [ ] ID-57
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L461) Calls stack
      containing the loop: MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-58
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-59
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L260-L267)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L264)
      Calls stack containing the loop:
      MoeTreasury.setAPRBatch(uint256[],uint256[])
      MoeTreasury.setAPR(uint256,uint256[])

source/contracts/MoeTreasury.sol#L260-L267

- [ ] ID-60
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-61
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L260-L267)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L264)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L260-L267

- [ ] ID-62
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-63
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L217)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-64
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-65
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L426-L428)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L427)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L426-L428

- [ ] ID-66
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L140-L158)
      has external calls inside a loop:
      [sov_minted[i] = _sov.mint(address(this),moe_amount[i])](source/contracts/MoeTreasury.sol#L153)

source/contracts/MoeTreasury.sol#L140-L158

- [ ] ID-67
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L217)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-68
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L217)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-69
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L524-L526)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L525) Calls stack
      containing the loop: MoeTreasury.setAPBBatch(uint256[],uint256[])
      MoeTreasury.setAPB(uint256,uint256[])

source/contracts/MoeTreasury.sol#L524-L526

- [ ] ID-70
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L461) Calls stack
      containing the loop: MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-71
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L210-L219)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L214)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L210-L219

- [ ] ID-72
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [oldAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L120)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-73
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L260-L267)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L264)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L260-L267

- [ ] ID-74
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L457-L469)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L462)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L457-L469

- [ ] ID-75
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L260-L267)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L264)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L260-L267

## reentrancy-benign

Impact: Low Confidence: Medium

- [ ] ID-76 Reentrancy in
      [Migratable._premigrate(address,uint256,uint256)](source/contracts/base/Migratable.sol#L126-L137):
      External calls:
  - [_base[index].burnFrom(account,amount)](source/contracts/base/Migratable.sol#L133)
    State variables written after the call(s):
  - [_migrated += new_amount](source/contracts/base/Migratable.sol#L135)

source/contracts/base/Migratable.sol#L126-L137

- [ ] ID-77 Reentrancy in
      [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L169):
      External calls:
  - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L158-L163)
    State variables written after the call(s):
  - [_age[account][nftId] -= Math.mulDiv(_age[account][nftId],amount,balanceOf(account,nftId))](source/contracts/APowerNft.sol#L164-L168)

source/contracts/APowerNft.sol#L152-L169

- [ ] ID-78 Reentrancy in
      [APowerNft._memoBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L209-L213):
      External calls:
  - [_pushBurn(account,nftId,amount)](source/contracts/APowerNft.sol#L210)
    - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L158-L163)
      State variables written after the call(s):
  - [_shares[level / 3] -= int256(amount * 10 ** level)](source/contracts/APowerNft.sol#L212)

source/contracts/APowerNft.sol#L209-L213

- [ ] ID-79 Reentrancy in
      [MoeTreasury.claim(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L119-L133):
      External calls:
  - [assert(bool)(_moe.approve(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L128)
  - [sov_minted = _sov.mint(address(this),moe_amount)](source/contracts/MoeTreasury.sol#L129)
  - [banq(account,amount,nonce)](source/contracts/MoeTreasury.sol#L124)
    - [assert(bool)(_token.approve(_pool,amount))](source/contracts/libs/Banq.sol#L72)
    - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L83)
    - [_token.burn(dif_balance - min_balance)](source/contracts/libs/Banq.sol#L57)
    - [assert(bool)(_token.transfer(account,min_balance))](source/contracts/libs/Banq.sol#L60)
    - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L101)
    - [assert(bool)(supply.transfer(account,assets))](source/contracts/libs/Banq.sol#L111)
      State variables written after the call(s):
  - [_minted[account][nftId] += sov_minted](source/contracts/MoeTreasury.sol#L131)

source/contracts/MoeTreasury.sol#L119-L133

- [ ] ID-80 Reentrancy in
      [MoeTreasury.claim(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L119-L133):
      External calls:
  - [banq(account,amount,nonce)](source/contracts/MoeTreasury.sol#L124)
    - [assert(bool)(_token.approve(_pool,amount))](source/contracts/libs/Banq.sol#L72)
    - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L83)
    - [_token.burn(dif_balance - min_balance)](source/contracts/libs/Banq.sol#L57)
    - [assert(bool)(_token.transfer(account,min_balance))](source/contracts/libs/Banq.sol#L60)
    - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L101)
    - [assert(bool)(supply.transfer(account,assets))](source/contracts/libs/Banq.sol#L111)
      State variables written after the call(s):
  - [_claimed[account][nftId] += moe_amount](source/contracts/MoeTreasury.sol#L126)

source/contracts/MoeTreasury.sol#L119-L133

## reentrancy-events

Impact: Low Confidence: Medium

- [ ] ID-81 Reentrancy in
      [NftTreasury.unstakeBatch(address,uint256[],uint256[])](source/contracts/NftTreasury.sol#L117-L130):
      External calls:
  - [_ppt.burnBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L126)
  - [_nft.safeBatchTransferFrom(address(this),account,nftIds,amounts,)](source/contracts/NftTreasury.sol#L127)
    Event emitted after the call(s):
  - [UnstakeBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L128)

source/contracts/NftTreasury.sol#L117-L130

- [ ] ID-82 Reentrancy in
      [NftTreasury.stake(address,uint256,uint256)](source/contracts/NftTreasury.sol#L36-L46):
      External calls:
  - [_nft.safeTransferFrom(account,address(this),nftId,amount,)](source/contracts/NftTreasury.sol#L42)
  - [_ppt.mint(account,nftId,amount)](source/contracts/NftTreasury.sol#L43)
    Event emitted after the call(s):
  - [Stake(account,nftId,amount)](source/contracts/NftTreasury.sol#L44)

source/contracts/NftTreasury.sol#L36-L46

- [ ] ID-83 Reentrancy in
      [NftTreasury.unstake(address,uint256,uint256)](source/contracts/NftTreasury.sol#L102-L111):
      External calls:
  - [_ppt.burn(account,nftId,amount)](source/contracts/NftTreasury.sol#L107)
  - [_nft.safeTransferFrom(address(this),account,nftId,amount,)](source/contracts/NftTreasury.sol#L108)
    Event emitted after the call(s):
  - [Unstake(account,nftId,amount)](source/contracts/NftTreasury.sol#L109)

source/contracts/NftTreasury.sol#L102-L111

- [ ] ID-84 Reentrancy in
      [NftTreasury.stakeBatch(address,uint256[],uint256[])](source/contracts/NftTreasury.sol#L52-L68):
      External calls:
  - [_nft.safeBatchTransferFrom(account,address(this),nftIds,amounts,)](source/contracts/NftTreasury.sol#L64)
  - [_ppt.mintBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L65)
    Event emitted after the call(s):
  - [StakeBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L66)

source/contracts/NftTreasury.sol#L52-L68

## timestamp

Impact: Low Confidence: Medium

- [ ] ID-85
      [NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])](source/contracts/base/NftMigratable.sol#L177-L188)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,error)(_deadlineBy >= block.timestamp,revert DeadlinePassed(uint256)(_deadlineBy))](source/contracts/base/NftMigratable.sol#L183)

source/contracts/base/NftMigratable.sol#L177-L188

- [ ] ID-86
      [NftMigratable.migratable(bool)](source/contracts/base/NftMigratable.sol#L225-L231)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,error)(_deadlineBy >= block.timestamp,revert DeadlinePassed(uint256)(_deadlineBy))](source/contracts/base/NftMigratable.sol#L226)
  - [flag && _migratable == 0](source/contracts/base/NftMigratable.sol#L227)

source/contracts/base/NftMigratable.sol#L225-L231

- [ ] ID-87 [Nft.year()](source/contracts/libs/Nft.sol#L50-L54) uses timestamp
      for comparisons Dangerous comparisons:
  - [require(bool,error)(anno > 2020,revert InvalidYear(uint256)(anno))](source/contracts/libs/Nft.sol#L52)

source/contracts/libs/Nft.sol#L50-L54

- [ ] ID-88
      [XPowerNft._redeemable(uint256)](source/contracts/XPowerNft.sol#L94-L97)
      uses timestamp for comparisons Dangerous comparisons:
  - [yearOf(id) + 2 ** (levelOf(id) / 3) - 1 <= year() || migratable()](source/contracts/XPowerNft.sol#L95-L96)

source/contracts/XPowerNft.sol#L94-L97

- [ ] ID-89 [XPower._recent(bytes32)](source/contracts/XPower.sol#L97-L99) uses
      timestamp for comparisons Dangerous comparisons:
  - [_timestamps[blockHash] >= currentInterval() * (3600)](source/contracts/XPower.sol#L98)

source/contracts/XPower.sol#L97-L99

- [ ] ID-90
      [NftMigratable._migrateFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L116-L125)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,error)(_deadlineBy >= block.timestamp,revert DeadlinePassed(uint256)(_deadlineBy))](source/contracts/base/NftMigratable.sol#L122)

source/contracts/base/NftMigratable.sol#L116-L125

- [ ] ID-91
      [NftMigratable.migratable()](source/contracts/base/NftMigratable.sol#L234-L239)
      uses timestamp for comparisons Dangerous comparisons:
  - [_migratable > 0](source/contracts/base/NftMigratable.sol#L235)
  - [block.timestamp >= _migratable](source/contracts/base/NftMigratable.sol#L236)

source/contracts/base/NftMigratable.sol#L234-L239

- [ ] ID-92
      [MoeTreasury.claim(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L119-L133)
      uses timestamp for comparisons Dangerous comparisons:
  - [assert(bool)(_moe.approve(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L128)
  - [require(bool,error)(sov_minted > 0,revert InvalidClaim(uint256)(nftId))](source/contracts/MoeTreasury.sol#L130)

source/contracts/MoeTreasury.sol#L119-L133

- [ ] ID-93
      [MoeTreasury.claimable(address,uint256)](source/contracts/MoeTreasury.sol#L181-L191)
      uses timestamp for comparisons Dangerous comparisons:
  - [generalReward > claimedReward](source/contracts/MoeTreasury.sol#L187)

source/contracts/MoeTreasury.sol#L181-L191

- [ ] ID-94
      [Migratable._premigrate(address,uint256,uint256)](source/contracts/base/Migratable.sol#L126-L137)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,error)(_deadlineBy >= block.timestamp,revert DeadlinePassed(uint256)(_deadlineBy))](source/contracts/base/Migratable.sol#L132)

source/contracts/base/Migratable.sol#L126-L137

## assembly

Impact: Informational Confidence: High

- [ ] ID-95
      [Banq._supply(address,uint256,uint256)](source/contracts/libs/Banq.sol#L71-L112)
      uses assembly
  - [INLINE ASM](source/contracts/libs/Banq.sol#L86-L88)
  - [INLINE ASM](source/contracts/libs/Banq.sol#L104-L106)

source/contracts/libs/Banq.sol#L71-L112

## low-level-calls

Impact: Informational Confidence: High

- [ ] ID-96 Low level call in
      [Banq._supply(address,uint256,uint256)](source/contracts/libs/Banq.sol#L71-L112):
  - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L83)
  - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L101)

source/contracts/libs/Banq.sol#L71-L112
