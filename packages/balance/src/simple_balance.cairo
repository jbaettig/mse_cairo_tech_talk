/// interface representing `SimpleBalance`
#[starknet::interface]
pub trait ISimpleBalance<TContractState> {
    /// increase contract balance
    fn increase_balance(ref self: TContractState, amount: felt252);

    /// retrieve contract balance
    fn get_balance(self: @TContractState) -> felt252;
}

/// simple balance contract
#[starknet::contract]
mod SimpleBalance {
    use core::starknet::{ContractAddress, get_execution_info};
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    // some error messages as felts
    mod Errors {
        pub const NOT_ZERO: felt252 = 'Balance: Amount cannot be 0.';
        pub const NOT_OWNER: felt252 = 'Balance: You are not the owner.';
    }

    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[abi(embed_v0)]
    impl SimpleBalanceImpl of super::ISimpleBalance<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, Errors::NOT_ZERO);
            self.balance.write(self.balance.read() + amount);
        }

        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}
