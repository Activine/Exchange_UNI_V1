## Decentralized exchange like Uniswap v1

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test -vv
```

### Deploy

```shell
$ source .env

$ forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Token.sol:Token

$ forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY --constructor-args <address of the token contract you just deployed> --etherscan-api-key $ETHERSCAN_API_KEY --verify src/Exchange.sol:Exchange
```

### Verify

```shell
$ forge verify-contract <contract_address> <contract_name> --chain <chain_name>
```
