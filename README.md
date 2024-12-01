# Smart Contract Programming with Cairo for Starknet

This repository contains examples of cairo programs and smart contracts written in **Cairo**, designed for deployment and execution on the **Starknet** validity rollup. The examples provided here showcase fundamental concepts and use cases of smart contract development in Cairo.

## Examples Included

### 0. Geometry

Some basic cairo code examples that give an overview of the language.

### 1. Storage Contract

A basic contract illustrating how to:

- Store and update data in the Starknet storage.
- Read and write operations in a gas-efficient manner.

### 2. Staking Contract

A simple staking mechanism allowing users to:

- Lock ERC-20 tokens in the contract.
- Withdraw staked tokens at any time.

### 3. ERC-20 Contract

A standard implementation of an ERC-20 token contract using ([OpenZeppelin](https://github.com/OpenZeppelin/cairo-contracts)). This example demonstrates:

- Token creation of a token using the ERC-20 componente provided by OpenZeppelin.

## Requirements

To run and deploy these examples, you'll need the following:

1. Install `asdf` ([instructions](https://asdf-vm.com/guide/getting-started.html))
2. Install Scarb `2.8.2` via `asdf` ([instructions](https://docs.swmansion.com/scarb/download.html#install-via-asdf))
3. Install Starknet Foundry `0.33.0` via `asdf` ([instructions](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html))
4. Install Rust via ([instructions](https://www.rust-lang.org/tools/install))

## Deployment

This guide provides instructions for declaring and deploying the provided smart contracts on Starknet using **sncast**. For detailed instructions, please refer to the [official sncast documentation](https://foundry-rs.github.io/starknet-foundry/starknet/sncast-overview.html).

### Prerequisites

- Ensure you have created an account using **sncast**.
- Obtain the RPC URL of your preferred provider.
- Decide on the fee token (`strk` or `eth`) for transaction fees.

### 1. Storage Contract

- Sepolia Address: `0x95b178dc68dfd28da710c5d025f87dc2cf1bd3fd355d7fa77b3ad468f68b3b`
- Deploy TX: `0xdd69d9d786c913975bb0925d7c38d3de0c8db0a690d87f399c027460078b34`

#### Declare

To declare the contract on Starknet, use the following command:

```zsh
sncast --account <ACCOUNT_NAME> declare --url <RPC_URL> --fee-token <FEE_TOKEN> --contract-name SimpleBalance --package balance
```

**Parameters:**

- `<ACCOUNT_NAME>`: The name of the account you created using sncast.
- `<RPC_URL>`: The URL of the RPC provider of your choice.
- `<FEE_TOKEN>`: The token with which you want to pay the fee. Possible values are:
  - strk
  - eth

After running the command, note the `CLASS_HASH` displayed in the command line output. This value is required for the deployment step.

#### Deploy

To deploy the declared contract, use the following command:

```zsh
sncast --account <ACCOUNT_NAME> deploy --url <RPC_URL> --fee-token <FEE_TOKEN> --class-hash <CLASS_HASH>
```

**Parameters:**

- `<ACCOUNT_NAME>`: The name of the account you created using sncast.
- `<RPC_URL>`: The URL of the RPC provider of your choice.
- `<FEE_TOKEN>`: The token with which you want to pay the fee. Possible values are:
  - strk
  - eth
- `<CLASS_HASH>`: The class hash of the contract obtained from the output of the declare command.

### 2. Staking Contract

- Sepolia Address: `0x29b4c3ccc560336020a31961bc875ad14958c36e2fd97f84d14add5528f58b9`
- Deploy TX: `0x10c5c47e1576af49d0b6bdfaf3e7c5bf5ada0e1210910fec8afd02dc3389b12`
- Token Address: `0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7` (ETHER)

#### Declare

To declare the contract on Starknet, use the following command:

```zsh
sncast --account <ACCOUNT_NAME> declare --url <RPC_URL> --fee-token <FEE_TOKEN> --contract-name SimpleStaking --package balance
```

**Parameters:**

- `<ACCOUNT_NAME>`: The name of the account you created using sncast.
- `<RPC_URL>`: The URL of the RPC provider of your choice.
- `<FEE_TOKEN>`: The token with which you want to pay the fee. Possible values are:
  - strk
  - eth

After running the command, note the `CLASS_HASH` displayed in the command line output. This value is required for the deployment step.

#### Deploy

To deploy the declared contract, use the following command:

```zsh
sncast --account <ACCOUNT_NAME> deploy --url <RPC_URL> --fee-token <FEE_TOKEN> --class-hash <CLASS_HASH> --constructor-calldata <TOKEN_ADDRESS>
```

**Parameters:**

- `<ACCOUNT_NAME>`: The name of the account you created using sncast.
- `<RPC_URL>`: The URL of the RPC provider of your choice.
- `<FEE_TOKEN>`: The token with which you want to pay the fee. Possible values are:
  - strk
  - eth
- `<CLASS_HASH>`: The class hash of the contract obtained from the output of the declare command.
- `<TOKEN_ADDRESS>`: The address of the staking token.

### 3. ERC-20 Contract

- Sepolia Address: `0x5bda077b9e6874cbeccddf934991582b50df31a06fef0c299dc990a186ff14e`
- Deploy TX: `0xc530396dbf1d0c4b669789e32f37a76b0db906054a3688cf118ace2c648732`

#### Declare

To declare the contract on Starknet, use the following command:

```zsh
sncast --account <ACCOUNT_NAME> declare --url <RPC_URL> --fee-token <FEE_TOKEN> --contract-name ZeppelinToken --package token
```

**Parameters:**

- `<ACCOUNT_NAME>`: The name of the account you created using sncast.
- `<RPC_URL>`: The URL of the RPC provider of your choice.
- `<FEE_TOKEN>`: The token with which you want to pay the fee. Possible values are:
  - strk
  - eth

After running the command, note the `CLASS_HASH` displayed in the command line output. This value is required for the deployment step.

#### Deploy

To deploy the declared contract, use the following command:

```zsh
sncast --account <ACCOUNT_NAME> deploy --url <RPC_URL> --fee-token <FEE_TOKEN> --class-hash <CLASS_HASH> --constructor-calldata <TOKEN_NAME> <TOKEN_SYMBOL> <RECIPIENT> <TOKEN_SUPPLY>
```

**Parameters:**

- `<ACCOUNT_NAME>`: The name of the account you created using sncast.
- `<RPC_URL>`: The URL of the RPC provider of your choice.
- `<FEE_TOKEN>`: The token with which you want to pay the fee. Possible values are:
  - strk
  - eth
- `<CLASS_HASH>`: The class hash of the contract obtained from the output of the declare command.
- `<TOKEN_NAME>`: The name of the token ([parsed as a felt array](https://docs.starknet.io/architecture-and-concepts/smart-contracts/serialization-of-cairo-types/#serialization_of_byte_arrays)).
- `<TOKEN_SYMBOL>`: The name of the token ([parsed as a felt array](https://docs.starknet.io/architecture-and-concepts/smart-contracts/serialization-of-cairo-types/#serialization_of_byte_arrays)).
- `<RECIPIENT>`: The address of the token recipient.
- `<TOKEN_SUPPLY>`: The total supply of the token ([parsed as a u256](https://docs.starknet.io/architecture-and-concepts/smart-contracts/serialization-of-cairo-types/#serialization_of_unsigned_integers)).
