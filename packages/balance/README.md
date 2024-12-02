# Live Coding Backup

## TX

**Declare:**

```zsh
sncast --account sepolia declare --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --contract-name SimpleBalance --package balance
```

**Deploy:**

```zsh
sncast --account sepolia deploy --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --class-hash <CLASS_HASH> --constructor-calldata 0x4064692c33647feaf3e38c103e24decf36207caa2b0a7b8e634e1ce6364de15
```

**Invoke:**

```zsh
sncast --account sepolia invoke --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --contract-address <CONTRACT_ADDRESS> --function "reset"
```

## Code

```rs
#[storage]
struct Storage {
    owner: ContractAddress,
    balance: felt252,
}

#[constructor]
fn constructor(ref self: ContractState, owner: ContractAddress) {
    self.owner.write(owner);
}

fn reset(ref self: ContractState) {
    let caller = get_execution_info().unbox().caller_address;
    assert(caller == self.owner.read(), Errors::NOT_OWNER);

    self.balance.write(0);
}
```
