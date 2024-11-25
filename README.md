# Smart Contract Programming with Cairo for Starknet

This repository contains examples of smart contracts written in **Cairo**, designed for deployment and execution on the **Starknet** validity rollup. The examples provided here showcase fundamental concepts and use cases of smart contract development in Cairo.

## Examples Included

### 1. Storage Contract

A basic contract illustrating how to:

- Store and update data in the Starknet storage.
- Read and write operations in a gas-efficient manner.

### 2. Staking Contract

A simple staking mechanism allowing users to:

- Lock ERC-20 tokens.
- Withdraw staked tokens.

### 3. ERC-20 Contract

A standard implementation of an ERC-20 token contract. This example demonstrates:

- Token creation with `name`, `symbol`, `decimals`, and `initial supply`.
- Core functionalities like `transfer`, `approve`, and `transferFrom`.
- Events for token transfer and approvals.

## Requirements

To run and deploy these examples, you'll need the following:

1. Install `asdf` ([instructions](https://asdf-vm.com/guide/getting-started.html))
2. Install Scarb `2.8.5` via `asdf` ([instructions](https://docs.swmansion.com/scarb/download.html#install-via-asdf))
3. Install Starknet Foundry `0.33.0` via `asdf` ([instructions](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html))
4. Install Rust via ([instructions](https://www.rust-lang.org/tools/install))
