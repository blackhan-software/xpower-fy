[![Main](https://github.com/blackhan-software/xpower-hh/actions/workflows/main.yaml/badge.svg)](https://github.com/blackhan-software/xpower-hh/actions/workflows/main.yaml)

# XPower Token

XPower is a proof-of-work token, i.e. it can only be minted by providing a correct nonce (with a recent block-hash). It has a maximum supply of 0.930T × 1E64 XPOW. To be exact, the maximum supply of the XPOW token is:

> 9304721456570051417965525581055278309637766624917545324597787815844239114240

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
$ alias forge-script="forge script -f $RPC_URL --private-key $PRIVATE_KEY0"
```

```shell
$ forge-script script/moe-v9c.s.sol [--broadcast]
$ forge-script script/nft-v9c.s.sol [--broadcast]
$ forge-script script/ppt-v9c.s.sol [--broadcast]
$ forge-script script/sov-v9c.s.sol [--broadcast]
$ forge-script script/mty-v9c.s.sol [--broadcast]
$ forge-script script/pty-v9c.s.sol [--broadcast]
```

### Verify

```shell
$ CHAIN_ID=43114 # default; or: 43113 for testnet
```

```shell
$ ./verify/moe-v9c.sh [$CHAIN_ID]
$ ./verify/nft-v9c.sh [$CHAIN_ID]
$ ./verify/ppt-v9c.sh [$CHAIN_ID]
$ ./verify/sov-v9c.sh [$CHAIN_ID]
$ ./verify/mty-v9c.sh [$CHAIN_ID]
$ ./verify/pty-v9c.sh [$CHAIN_ID]
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

© 2024 [Moorhead LLC](#)
