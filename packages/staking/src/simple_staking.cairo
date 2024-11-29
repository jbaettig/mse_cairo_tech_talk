/// interface representing `SimpleStaking`
#[starknet::interface]
pub trait ISimpleStaking<TContractState> {
    /// deposit tokens
    fn deposit(ref self: TContractState, amount: u256);

    /// withdraw tokens
    fn withdraw(ref self: TContractState, amount: u256);

    /// withdraw all tokens
    fn withdraw_all(ref self: TContractState);

    /// balance of the given address
    fn stake(self: @TContractState, address: starknet::ContractAddress) -> u256;

    /// balance of the staking contract
    fn total_stake(self: @TContractState) -> u256;

    /// address of the token
    fn token_address(self: @TContractState) -> starknet::ContractAddress;
}

/// simple staking contract
#[starknet::contract]
mod SimpleStaking {
    use core::num::traits::Zero;

    use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    use starknet::{ContractAddress, get_execution_info};
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    mod Errors {
        pub const APPROVE_FIRST: felt252 = 'STAKING: Approve stake first.';
        pub const NO_STAKE: felt252 = 'STAKING: No stake to withdraw.';
        pub const TRANSFER: felt252 = 'STAKING: Transfer error.';
        pub const WITHDRAWL_TO_BIG: felt252 = 'STAKING: Withdrawl to big.';
        pub const ADDRESS_ZERO: felt252 = 'STAKING: Address is zero.';
    }

    #[storage]
    struct Storage {
        total_stake: u256,
        token_contract: ContractAddress,
        stake: Map<ContractAddress, u256>
    }

    #[constructor]
    fn constructor(ref self: ContractState, token_contract: ContractAddress) {
        assert(Zero::is_non_zero(@token_contract), Errors::ADDRESS_ZERO);
        self.token_contract.write(token_contract);
    }

    #[abi(embed_v0)]
    impl SimpleStakingImpl of super::ISimpleStaking<ContractState> {
        fn deposit(ref self: ContractState, amount: u256) {
            let caller_address = get_execution_info().unbox().caller_address;
            let contract_address = get_execution_info().unbox().contract_address;
            let token_address = self.token_contract.read();

            let token_dispatcher = IERC20Dispatcher { contract_address: token_address };
            let allowance = token_dispatcher.allowance(caller_address, contract_address);
            assert(amount <= allowance, Errors::APPROVE_FIRST);
            let success = token_dispatcher.transfer_from(caller_address, contract_address, amount);
            assert(success, Errors::TRANSFER);

            let current_stake = self.stake.read(caller_address);
            self.stake.write(caller_address, current_stake + amount);

            let total_stake = self.total_stake.read();
            self.total_stake.write(total_stake + amount);
        }

        fn withdraw_all(ref self: ContractState) {
            let caller_address = get_execution_info().unbox().caller_address;
            let caller_total_stake = self.stake.read(caller_address);

            _withdraw(ref self, caller_total_stake);
        }

        fn withdraw(ref self: ContractState, amount: u256) {
            _withdraw(ref self, amount)
        }

        fn stake(self: @ContractState, address: ContractAddress) -> u256 {
            self.stake.read(address)
        }

        fn total_stake(self: @ContractState) -> u256 {
            self.total_stake.read()
        }

        fn token_address(self: @ContractState) -> ContractAddress {
            self.token_contract.read()
        }
    }

    fn _withdraw(ref self: ContractState, amount: u256) {
        let caller_address = get_execution_info().unbox().caller_address;
        let staker_total_stake = self.stake.read(caller_address);
        assert(amount <= staker_total_stake, Errors::WITHDRAWL_TO_BIG);
        assert(amount != 0_u256, Errors::NO_STAKE);
        let token_address = self.token_contract.read();

        let token_dispatcher = IERC20Dispatcher { contract_address: token_address };
        let success = token_dispatcher.transfer(caller_address, amount);
        assert(success, Errors::TRANSFER);

        self.stake.write(caller_address, staker_total_stake - amount);

        let total_stake = self.total_stake.read();
        self.total_stake.write(total_stake - amount);
    }
}
