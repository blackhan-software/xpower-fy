# Slither Report

```sh
slither . \
    --exclude=naming-conventions \
    --filter-paths=node_modules \
    --show-ignored-findings \
    --checklist > slither.md
```

## Summary

- [arbitrary-send-erc20](#arbitrary-send-erc20) (2 results) (High)
- [reentrancy-no-eth](#reentrancy-no-eth) (3 results) (Medium)
- [unused-return](#unused-return) (1 results) (Medium)
- [missing-zero-check](#missing-zero-check) (1 results) (Low)
- [calls-loop](#calls-loop) (67 results) (Low)
- [reentrancy-benign](#reentrancy-benign) (5 results) (Low)
- [reentrancy-events](#reentrancy-events) (4 results) (Low)
- [timestamp](#timestamp) (12 results) (Low)
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
      [XPowerNft._depositFrom(address,uint256,uint256)](source/contracts/XPowerNft.sol#L39-L52)
      uses arbitrary from in transferFrom:
      [assert(bool)(_moe.transferFrom(account,address(this),moeAmount * 10 ** _moe.decimals()))](source/contracts/XPowerNft.sol#L45-L51)

source/contracts/XPowerNft.sol#L39-L52

## reentrancy-no-eth

Impact: Medium Confidence: Medium

- [ ] ID-2 Reentrancy in
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L131-L149):
      External calls:
  - [assert(bool)(_moe.increaseAllowance(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L143)
  - [sov_amounts[i] = _sov.mint(address(this),moe_amounts[i])](source/contracts/MoeTreasury.sol#L144)
  - [banq(account,amount,nonce)](source/contracts/MoeTreasury.sol#L136)
    - [assert(bool)(_token.increaseAllowance(_pool,amount))](source/contracts/libs/Banq.sol#L59)
    - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L70)
    - [_token.burn(dif_balance - min_balance)](source/contracts/libs/Banq.sol#L51)
    - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L88)
    - [assert(bool)(supply.transfer(account,assets))](source/contracts/libs/Banq.sol#L98)
      State variables written after the call(s):
  - [_claimed[account][nftIds[i]] += moe_amounts[i]](source/contracts/MoeTreasury.sol#L141)
    [MoeTreasury._claimed](source/contracts/MoeTreasury.sol#L37) can be used in
    cross function reentrancies:
  - [MoeTreasury.claimed(address,uint256)](source/contracts/MoeTreasury.sol#L152-L157)
  - [MoeTreasury.refreshClaimed(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L57-L68)
  - [_minted[account][nftIds[i]] += sov_amounts[i]](source/contracts/MoeTreasury.sol#L146)
    [MoeTreasury._minted](source/contracts/MoeTreasury.sol#L39) can be used in
    cross function reentrancies:
  - [MoeTreasury.minted(address,uint256)](source/contracts/MoeTreasury.sol#L71-L76)

source/contracts/MoeTreasury.sol#L131-L149

- [ ] ID-3 Reentrancy in
      [APowerNft.safeTransferFrom(address,address,uint256,uint256,bytes)](source/contracts/APowerNft.sol#L43-L53):
      External calls:
  - [_pushBurn(account,nftId,amount)](source/contracts/APowerNft.sol#L50)
    - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L157-L162)
      State variables written after the call(s):
  - [_pushMint(to,nftId,amount)](source/contracts/APowerNft.sol#L51)
    - [_age[account][nftId] += amount * block.timestamp](source/contracts/APowerNft.sol#L133)
      [APowerNft._age](source/contracts/APowerNft.sol#L16) can be used in cross
      function reentrancies:
  - [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L168)
  - [APowerNft._pushMint(address,uint256,uint256)](source/contracts/APowerNft.sol#L132-L134)
  - [APowerNft.ageOf(address,uint256)](source/contracts/APowerNft.sol#L114-L124)

source/contracts/APowerNft.sol#L43-L53

- [ ] ID-4 Reentrancy in
      [APowerNft.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)](source/contracts/APowerNft.sol#L57-L67):
      External calls:
  - [_pushBurnBatch(account,nftIds,amounts)](source/contracts/APowerNft.sol#L64)
    - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L157-L162)
      State variables written after the call(s):
  - [_pushMintBatch(to,nftIds,amounts)](source/contracts/APowerNft.sol#L65)
    - [_age[account][nftId] += amount * block.timestamp](source/contracts/APowerNft.sol#L133)
      [APowerNft._age](source/contracts/APowerNft.sol#L16) can be used in cross
      function reentrancies:
  - [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L168)
  - [APowerNft._pushMint(address,uint256,uint256)](source/contracts/APowerNft.sol#L132-L134)
  - [APowerNft.ageOf(address,uint256)](source/contracts/APowerNft.sol#L114-L124)

source/contracts/APowerNft.sol#L57-L67

## unused-return

Impact: Medium Confidence: Medium

- [ ] ID-5
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      ignores return value by
      [_moe.migrateFrom(account,moeAmount * 10 ** _moe.decimals(),moeIndex)](source/contracts/XPowerNft.sol#L121)

source/contracts/XPowerNft.sol#L111-L127

## missing-zero-check

Impact: Low Confidence: Medium

- [ ] ID-6 [Banq.init(address).pool](source/contracts/libs/Banq.sol#L23) lacks a
      zero-check on : - [_pool = pool](source/contracts/libs/Banq.sol#L25)

source/contracts/libs/Banq.sol#L23

## calls-loop

Impact: Low Confidence: Medium

- [ ] ID-7
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-8
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L417-L419)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L418)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L417-L419

- [ ] ID-9
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L417-L419)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L418)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L417-L419

- [ ] ID-10
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L251-L258)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L255)
      Calls stack containing the loop:
      MoeTreasury.setAPRBatch(uint256[],uint256[])
      MoeTreasury.setAPR(uint256,uint256[])

source/contracts/MoeTreasury.sol#L251-L258

- [ ] ID-11
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L515-L517)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L516) Calls stack
      containing the loop: MoeTreasury.setAPBBatch(uint256[],uint256[])
      MoeTreasury.setAPB(uint256,uint256[])

source/contracts/MoeTreasury.sol#L515-L517

- [ ] ID-12
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-13
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L208)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-14
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [newAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L122)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-15
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L207)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-16
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L417-L419)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L418)
      Calls stack containing the loop: MoeTreasury.refreshRates(bool)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L417-L419

- [ ] ID-17
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L453)
      Calls stack containing the loop:
      MoeTreasury.setAPBBatch(uint256[],uint256[])
      MoeTreasury.setAPB(uint256,uint256[])

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-18
      [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L168)
      has external calls inside a loop:
      [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L157-L162)
      Calls stack containing the loop:
      APowerNft.burnBatch(address,uint256[],uint256[])
      APowerNft._memoBurnBatch(address,uint256[],uint256[])
      APowerNft._memoBurn(address,uint256,uint256)

source/contracts/APowerNft.sol#L152-L168

- [ ] ID-19
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L515-L517)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L516) Calls stack
      containing the loop: MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L515-L517

- [ ] ID-20
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L251-L258)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L255)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L251-L258

- [ ] ID-21
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [assert(bool)(_moe.transferFrom(account,address(this),migAmount))](source/contracts/XPowerNft.sol#L125)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-22
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L207)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-23
      [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L168)
      has external calls inside a loop:
      [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L157-L162)
      Calls stack containing the loop:
      APowerNft.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)
      APowerNft._pushBurnBatch(address,uint256[],uint256[])

source/contracts/APowerNft.sol#L152-L168

- [ ] ID-24
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L452) Calls stack
      containing the loop: MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-25
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [newAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L122)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-26
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L208)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-27
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L131-L149)
      has external calls inside a loop:
      [sov_amounts[i] = _sov.mint(address(this),moe_amounts[i])](source/contracts/MoeTreasury.sol#L144)

source/contracts/MoeTreasury.sol#L131-L149

- [ ] ID-28
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-29
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L453)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-30
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L207)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-31
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L453)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-32
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L205)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-33
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L208)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-34
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L251-L258)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L255)
      Calls stack containing the loop: MoeTreasury.refreshRates(bool)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L251-L258

- [ ] ID-35
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L251-L258)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L255)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L251-L258

- [ ] ID-36
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [_moe.migrateFrom(account,moeAmount * 10 ** _moe.decimals(),moeIndex)](source/contracts/XPowerNft.sol#L121)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-37
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L417-L419)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L418)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L417-L419

- [ ] ID-38
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L452) Calls stack
      containing the loop: MoeTreasury.setAPBBatch(uint256[],uint256[])
      MoeTreasury.setAPB(uint256,uint256[])

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-39
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L452) Calls stack
      containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-40
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [oldAmount = _moe.balanceOf(account)](source/contracts/XPowerNft.sol#L120)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-41
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-42
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L131-L149)
      has external calls inside a loop:
      [assert(bool)(_moe.increaseAllowance(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L143)

source/contracts/MoeTreasury.sol#L131-L149

- [ ] ID-43
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-44
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-45
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [_moe.migrateFrom(account,moeAmount * 10 ** _moe.decimals(),moeIndex)](source/contracts/XPowerNft.sol#L121)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-46
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-47
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L453)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-48
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,nftId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-49
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L205)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-50
      [XPowerNft._migrateDeposit(address,uint256,uint256,uint256[])](source/contracts/XPowerNft.sol#L111-L127)
      has external calls inside a loop:
      [assert(bool)(_moe.transferFrom(account,address(this),migAmount))](source/contracts/XPowerNft.sol#L125)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/XPowerNft.sol#L111-L127

- [ ] ID-51
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L251-L258)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L255)
      Calls stack containing the loop:
      MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L251-L258

- [ ] ID-52
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-53
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L515-L517)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L516) Calls stack
      containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L515-L517

- [ ] ID-54
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L417-L419)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L418)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256) MoeTreasury.getAPR(uint256)

source/contracts/MoeTreasury.sol#L417-L419

- [ ] ID-55
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [reward = rate * age * 10 ** _moe.decimals()](source/contracts/MoeTreasury.sol#L207)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-56
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nftYear = _ppt.yearOf(nftId)](source/contracts/MoeTreasury.sol#L453)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-57
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateBatch(uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-58
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L452) Calls stack
      containing the loop: MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-59
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [_base[index[0]].burn(account,tryId,amount)](source/contracts/base/NftMigratable.sol#L137)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-60
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L515-L517)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L516) Calls stack
      containing the loop: MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L515-L517

- [ ] ID-61
      [NftMigratable._burnFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L128-L138)
      has external calls inside a loop:
      [tryBalance = _base[index[0]].balanceOf(account,tryId)](source/contracts/base/NftMigratable.sol#L136)
      Calls stack containing the loop:
      NftMigratable.migrateFromBatch(address,uint256[],uint256[],uint256[])
      NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])
      XPowerNft._burnFrom(address,uint256,uint256,uint256[])

source/contracts/base/NftMigratable.sol#L128-L138

- [ ] ID-62
      [MoeTreasury.refreshRates(bool)](source/contracts/MoeTreasury.sol#L325-L356)
      has external calls inside a loop:
      [id = _ppt.idBy(2021,3 * i)](source/contracts/MoeTreasury.sol#L330)

source/contracts/MoeTreasury.sol#L325-L356

- [ ] ID-63
      [MoeTreasury.apbTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L448-L460)
      has external calls inside a loop:
      [nowYear = _ppt.year()](source/contracts/MoeTreasury.sol#L452) Calls stack
      containing the loop: MoeTreasury.mintableBatch(address,uint256[])
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256)

source/contracts/MoeTreasury.sol#L448-L460

- [ ] ID-64
      [MoeTreasury._apbId(uint256)](source/contracts/MoeTreasury.sol#L515-L517)
      has external calls inside a loop:
      [_ppt.idBy(2021,3)](source/contracts/MoeTreasury.sol#L516) Calls stack
      containing the loop: MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.apbOf(uint256)
      MoeTreasury.apbTargetOf(uint256) MoeTreasury.getAPB(uint256)

source/contracts/MoeTreasury.sol#L515-L517

- [ ] ID-65 [APower.decimals()](source/contracts/APower.sol#L48-L50) has
      external calls inside a loop:
      [_moe.decimals()](source/contracts/APower.sol#L49) Calls stack containing
      the loop: APower.mintableBatch(uint256[])
      APower._mintable(uint256,uint256,uint256)

source/contracts/APower.sol#L48-L50

- [ ] ID-66
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L205)
      Calls stack containing the loop:
      MoeTreasury.claimBatch(address,uint256[],uint256,uint256)
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-67
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [denomination = _ppt.denominationOf(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L208)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

- [ ] ID-68
      [MoeTreasury.refreshable()](source/contracts/MoeTreasury.sol#L359-L388)
      has external calls inside a loop:
      [id = _ppt.idBy(2021,3 * i)](source/contracts/MoeTreasury.sol#L363)

source/contracts/MoeTreasury.sol#L359-L388

- [ ] ID-69
      [MoeTreasury.claimBatch(address,uint256[],uint256,uint256)](source/contracts/MoeTreasury.sol#L131-L149)
      has external calls inside a loop:
      [moe_wrap = _sov.wrappable(moe_amounts[i])](source/contracts/MoeTreasury.sol#L142)

source/contracts/MoeTreasury.sol#L131-L149

- [ ] ID-70
      [MoeTreasury._aprId(uint256)](source/contracts/MoeTreasury.sol#L417-L419)
      has external calls inside a loop:
      [_ppt.idBy(2021,_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L418)
      Calls stack containing the loop:
      MoeTreasury.setAPRBatch(uint256[],uint256[])
      MoeTreasury.setAPR(uint256,uint256[])

source/contracts/MoeTreasury.sol#L417-L419

- [ ] ID-71
      [MoeTreasury.aprTargetOf(uint256,uint256[])](source/contracts/MoeTreasury.sol#L251-L258)
      has external calls inside a loop:
      [rate = Polynomial(array).eval3(_ppt.levelOf(nftId))](source/contracts/MoeTreasury.sol#L255)
      Calls stack containing the loop:
      MoeTreasury.claimableBatch(address,uint256[])
      MoeTreasury.rewardOfBatch(address,uint256[])
      MoeTreasury.rewardOf(address,uint256) MoeTreasury.aprOf(uint256)
      MoeTreasury.aprTargetOf(uint256)

source/contracts/MoeTreasury.sol#L251-L258

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
      [MoeTreasury.rewardOf(address,uint256)](source/contracts/MoeTreasury.sol#L201-L210)
      has external calls inside a loop:
      [age = _ppt.ageOf(account,nftId)](source/contracts/MoeTreasury.sol#L205)
      Calls stack containing the loop:
      MoeTreasury.rewardOfBatch(address,uint256[])

source/contracts/MoeTreasury.sol#L201-L210

## reentrancy-benign

Impact: Low Confidence: Medium

- [ ] ID-74 Reentrancy in
      [APowerNft._memoBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L208-L212):
      External calls:
  - [_pushBurn(account,nftId,amount)](source/contracts/APowerNft.sol#L209)
    - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L157-L162)
      State variables written after the call(s):
  - [_shares[level / 3] -= int256(amount * 10 ** level)](source/contracts/APowerNft.sol#L211)

source/contracts/APowerNft.sol#L208-L212

- [ ] ID-75 Reentrancy in
      [MoeTreasury.claim(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L110-L124):
      External calls:
  - [banq(account,amount,nonce)](source/contracts/MoeTreasury.sol#L115)
    - [assert(bool)(_token.increaseAllowance(_pool,amount))](source/contracts/libs/Banq.sol#L59)
    - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L70)
    - [_token.burn(dif_balance - min_balance)](source/contracts/libs/Banq.sol#L51)
    - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L88)
    - [assert(bool)(supply.transfer(account,assets))](source/contracts/libs/Banq.sol#L98)
      State variables written after the call(s):
  - [_claimed[account][nftId] += moe_amount](source/contracts/MoeTreasury.sol#L117)

source/contracts/MoeTreasury.sol#L110-L124

- [ ] ID-76 Reentrancy in
      [APowerNft._pushBurn(address,uint256,uint256)](source/contracts/APowerNft.sol#L152-L168):
      External calls:
  - [_mty.refreshClaimed(account,nftId,balanceOf(account,nftId),balanceOf(account,nftId) - amount)](source/contracts/APowerNft.sol#L157-L162)
    State variables written after the call(s):
  - [_age[account][nftId] -= Math.mulDiv(_age[account][nftId],amount,balanceOf(account,nftId))](source/contracts/APowerNft.sol#L163-L167)

source/contracts/APowerNft.sol#L152-L168

- [ ] ID-77 Reentrancy in
      [Migratable._premigrate(address,uint256,uint256)](source/contracts/base/Migratable.sol#L126-L138):
      External calls:
  - [_base[index].burnFrom(account,amount)](source/contracts/base/Migratable.sol#L134)
    State variables written after the call(s):
  - [_migrated += new_amount](source/contracts/base/Migratable.sol#L136)

source/contracts/base/Migratable.sol#L126-L138

- [ ] ID-78 Reentrancy in
      [MoeTreasury.claim(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L110-L124):
      External calls:
  - [assert(bool)(_moe.increaseAllowance(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L119)
  - [sov_amount = _sov.mint(address(this),moe_amount)](source/contracts/MoeTreasury.sol#L120)
  - [banq(account,amount,nonce)](source/contracts/MoeTreasury.sol#L115)
    - [assert(bool)(_token.increaseAllowance(_pool,amount))](source/contracts/libs/Banq.sol#L59)
    - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L70)
    - [_token.burn(dif_balance - min_balance)](source/contracts/libs/Banq.sol#L51)
    - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L88)
    - [assert(bool)(supply.transfer(account,assets))](source/contracts/libs/Banq.sol#L98)
      State variables written after the call(s):
  - [_minted[account][nftId] += sov_amount](source/contracts/MoeTreasury.sol#L122)

source/contracts/MoeTreasury.sol#L110-L124

## reentrancy-events

Impact: Low Confidence: Medium

- [ ] ID-79 Reentrancy in
      [NftTreasury.unstakeBatch(address,uint256[],uint256[])](source/contracts/NftTreasury.sol#L115-L128):
      External calls:
  - [_ppt.burnBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L124)
  - [_nft.safeBatchTransferFrom(address(this),account,nftIds,amounts,)](source/contracts/NftTreasury.sol#L125)
    Event emitted after the call(s):
  - [UnstakeBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L126)

source/contracts/NftTreasury.sol#L115-L128

- [ ] ID-80 Reentrancy in
      [NftTreasury.stakeBatch(address,uint256[],uint256[])](source/contracts/NftTreasury.sol#L50-L66):
      External calls:
  - [_nft.safeBatchTransferFrom(account,address(this),nftIds,amounts,)](source/contracts/NftTreasury.sol#L62)
  - [_ppt.mintBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L63)
    Event emitted after the call(s):
  - [StakeBatch(account,nftIds,amounts)](source/contracts/NftTreasury.sol#L64)

source/contracts/NftTreasury.sol#L50-L66

- [ ] ID-81 Reentrancy in
      [NftTreasury.stake(address,uint256,uint256)](source/contracts/NftTreasury.sol#L34-L44):
      External calls:
  - [_nft.safeTransferFrom(account,address(this),nftId,amount,)](source/contracts/NftTreasury.sol#L40)
  - [_ppt.mint(account,nftId,amount)](source/contracts/NftTreasury.sol#L41)
    Event emitted after the call(s):
  - [Stake(account,nftId,amount)](source/contracts/NftTreasury.sol#L42)

source/contracts/NftTreasury.sol#L34-L44

- [ ] ID-82 Reentrancy in
      [NftTreasury.unstake(address,uint256,uint256)](source/contracts/NftTreasury.sol#L100-L109):
      External calls:
  - [_ppt.burn(account,nftId,amount)](source/contracts/NftTreasury.sol#L105)
  - [_nft.safeTransferFrom(address(this),account,nftId,amount,)](source/contracts/NftTreasury.sol#L106)
    Event emitted after the call(s):
  - [Unstake(account,nftId,amount)](source/contracts/NftTreasury.sol#L107)

source/contracts/NftTreasury.sol#L100-L109

## timestamp

Impact: Low Confidence: Medium

- [ ] ID-83
      [NftMigratable._migrateFrom(address,uint256,uint256,uint256[])](source/contracts/base/NftMigratable.sol#L116-L125)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,string)(_deadlineBy >= block.timestamp,deadline passed)](source/contracts/base/NftMigratable.sol#L122)

source/contracts/base/NftMigratable.sol#L116-L125

- [ ] ID-84
      [Migratable._premigrate(address,uint256,uint256)](source/contracts/base/Migratable.sol#L126-L138)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,string)(_deadlineBy >= timestamp,deadline passed)](source/contracts/base/Migratable.sol#L133)

source/contracts/base/Migratable.sol#L126-L138

- [ ] ID-85 [XPower._recent(bytes32)](source/contracts/XPower.sol#L96-L98) uses
      timestamp for comparisons Dangerous comparisons:
  - [_timestamps[blockHash] >= currentInterval() * (3600)](source/contracts/XPower.sol#L97)

source/contracts/XPower.sol#L96-L98

- [ ] ID-86
      [NftMigratable.migratable(bool)](source/contracts/base/NftMigratable.sol#L225-L231)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,string)(_deadlineBy >= block.timestamp,deadline passed)](source/contracts/base/NftMigratable.sol#L226)
  - [flag && _migratable == 0](source/contracts/base/NftMigratable.sol#L227)

source/contracts/base/NftMigratable.sol#L225-L231

- [ ] ID-87 [APower.unwrappable(uint256)](source/contracts/APower.sol#L125-L132)
      uses timestamp for comparisons Dangerous comparisons:
  - [supply > 0](source/contracts/APower.sol#L128)

source/contracts/APower.sol#L125-L132

- [ ] ID-88
      [XPowerNft._redeemable(uint256)](source/contracts/XPowerNft.sol#L94-L97)
      uses timestamp for comparisons Dangerous comparisons:
  - [yearOf(id) + 2 ** (levelOf(id) / 3) - 1 <= year() || migratable()](source/contracts/XPowerNft.sol#L95-L96)

source/contracts/XPowerNft.sol#L94-L97

- [ ] ID-89
      [NftMigratable._migrateFromBatch(address,uint256[],uint256[],uint256[])](source/contracts/base/NftMigratable.sol#L177-L188)
      uses timestamp for comparisons Dangerous comparisons:
  - [require(bool,string)(_deadlineBy >= block.timestamp,deadline passed)](source/contracts/base/NftMigratable.sol#L183)

source/contracts/base/NftMigratable.sol#L177-L188

- [ ] ID-90 [APower.metric()](source/contracts/APower.sol#L135-L142) uses
      timestamp for comparisons Dangerous comparisons:
  - [supply > 0](source/contracts/APower.sol#L138)

source/contracts/APower.sol#L135-L142

- [ ] ID-91 [Nft.year()](source/contracts/libs/Nft.sol#L50-L54) uses timestamp
      for comparisons Dangerous comparisons:
  - [require(bool,string)(anno > 2020,invalid year)](source/contracts/libs/Nft.sol#L52)

source/contracts/libs/Nft.sol#L50-L54

- [ ] ID-92
      [NftMigratable.migratable()](source/contracts/base/NftMigratable.sol#L234-L239)
      uses timestamp for comparisons Dangerous comparisons:
  - [_migratable > 0](source/contracts/base/NftMigratable.sol#L235)
  - [block.timestamp >= _migratable](source/contracts/base/NftMigratable.sol#L236)

source/contracts/base/NftMigratable.sol#L234-L239

- [ ] ID-93
      [MoeTreasury.claimable(address,uint256)](source/contracts/MoeTreasury.sol#L172-L182)
      uses timestamp for comparisons Dangerous comparisons:
  - [generalReward > claimedReward](source/contracts/MoeTreasury.sol#L178)

source/contracts/MoeTreasury.sol#L172-L182

- [ ] ID-94
      [MoeTreasury.claim(address,uint256,uint256,uint256)](source/contracts/MoeTreasury.sol#L110-L124)
      uses timestamp for comparisons Dangerous comparisons:
  - [assert(bool)(_moe.increaseAllowance(address(_sov),moe_wrap))](source/contracts/MoeTreasury.sol#L119)
  - [require(bool,string)(sov_amount > 0,invalid claim)](source/contracts/MoeTreasury.sol#L121)

source/contracts/MoeTreasury.sol#L110-L124

## assembly

Impact: Informational Confidence: High

- [ ] ID-95
      [Banq._supply(address,uint256,uint256)](source/contracts/libs/Banq.sol#L58-L99)
      uses assembly
  - [INLINE ASM](source/contracts/libs/Banq.sol#L73-L75)
  - [INLINE ASM](source/contracts/libs/Banq.sol#L91-L93)

source/contracts/libs/Banq.sol#L58-L99

## low-level-calls

Impact: Informational Confidence: High

- [ ] ID-96 Low level call in
      [Banq._supply(address,uint256,uint256)](source/contracts/libs/Banq.sol#L58-L99):
  - [(ok1,data1) = _pool.call(args1)](source/contracts/libs/Banq.sol#L70)
  - [(ok2,data2) = _pool.call(args2)](source/contracts/libs/Banq.sol#L88)

source/contracts/libs/Banq.sol#L58-L99
