# XPower Token

XPower is a proof-of-work token, i.e. it can only be minted by providing a
correct nonce (with a recent block-hash).

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ cp .env-avalanche-main .env && source .env
```

```shell
$ alias forge-script="forge script -f $FORK_URL --private-key $PRIVATE_KEY0"
```

#### Create Contracts

```shell
$ forge-script script/moe-10a.s.sol --broadcast --verify
$ forge-script script/nft-10a.s.sol --broadcast --verify
$ forge-script script/ppt-10a.s.sol --broadcast --verify
$ forge-script script/sov-10a.s.sol --broadcast --verify
$ forge-script script/mty-10a.s.sol --broadcast --verify
$ forge-script script/nty-10a.s.sol --broadcast --verify
```

#### Transfer Roles

```shell
$ forge-script script/moe-10a.role.s.sol --broadcast
$ forge-script script/nft-10a.role.s.sol --broadcast
$ forge-script script/ppt-10a.role.s.sol --broadcast
$ forge-script script/sov-10a.role.s.sol --broadcast
$ forge-script script/mty-10a.role.s.sol --broadcast
$ forge-script script/nty-10a.role.s.sol --broadcast
```

### Verify

```shell
$ CHAIN_ID=43114 # default; or: 43113 for testnet
```

```shell
$ ./verify/moe-10a.sh [$CHAIN_ID]
$ ./verify/nft-10a.sh [$CHAIN_ID]
$ ./verify/ppt-10a.sh [$CHAIN_ID]
$ ./verify/sov-10a.sh [$CHAIN_ID]
$ ./verify/mty-10a.sh [$CHAIN_ID]
$ ./verify/nty-10a.sh [$CHAIN_ID]
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Copyright

© 2025 [Moorhead LLC](#)
