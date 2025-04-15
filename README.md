# XPower Token

XPower is a proof-of-work token, i.e. it can only be minted by providing a
correct nonce (with a recent block-hash).

## Usage

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```

### Anvil

```shell
anvil
```

### Deploy

```shell
cp .env.mainnet .env && source .env
```

```shell
alias forge-script="forge script --broadcast -f $FORK_URL --private-key $PRIVATE_KEY0"
```

#### Create Contracts

```shell
forge-script script/moe/moe-10a.s.sol --verify
```

```shell
forge-script script/nft/nft-10a.s.sol --verify
```

```shell
forge-script script/ppt/ppt-10a.s.sol --verify
```

```shell
forge-script script/sov/sov-10a.s.sol --verify
```

```shell
forge-script script/mty/mty-10a.s.sol --verify
```

```shell
forge-script script/nty/nty-10a.s.sol --verify
```

#### Transfer Roles

```shell
forge-script script/moe/moe-10a.role.s.sol
```

```shell
forge-script script/nft/nft-10a.role.s.sol
```

```shell
forge-script script/ppt/ppt-10a.role.s.sol
```

```shell
forge-script script/sov/sov-10a.role.s.sol
```

```shell
forge-script script/mty/mty-10a.role.s.sol
```

### Verify

```shell
CHAIN_ID=43114 # default; or: 43113 for testnet
```

```shell
./verify/moe-10a.sh [$CHAIN_ID]
```

```shell
./verify/nft-10a.sh [$CHAIN_ID]
```

```shell
./verify/ppt-10a.sh [$CHAIN_ID]
```

```shell
./verify/sov-10a.sh [$CHAIN_ID]
```

```shell
./verify/mty-10a.sh [$CHAIN_ID]
```

```shell
./verify/nty-10a.sh [$CHAIN_ID]
```

### Cast

```shell
cast <subcommand>
```

### Help

```shell
forge --help
```

```shell
anvil --help
```

```shell
cast --help
```

## Copyright

© 2025 [Moorhead LLC](#)
