use openzeppelin_token::erc20::interface::IERC20Dispatcher;
use openzeppelin_token::erc20::interface::IERC20DispatcherTrait;
use staking::simple_staking::ISimpleStakingDispatcher;
use staking::simple_staking::ISimpleStakingDispatcherTrait;
use staking::simple_staking::ISimpleStakingSafeDispatcher;
use staking::simple_staking::ISimpleStakingSafeDispatcherTrait;

use snforge_std::{cheat_caller_address, CheatSpan};

use utility::{token_params, token_owner, TOKEN_SUPPLY};

#[test]
#[available_gas(880)]
fn stake_with_allowance() {
    let token_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address: token_address };

    let staking_address = utility::deploy_contract("SimpleStaking", staking_params(token_address));
    let staking_dispatcher = ISimpleStakingDispatcher { contract_address: staking_address };

    let owner = token_owner();

    // approve the staking contract to spend tokens of owner
    let approval_amount = 42_u256;
    cheat_caller_address(token_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.approve(staking_address, approval_amount);

    // deposit tokens into the staking contract
    let stake_amount = approval_amount;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    staking_dispatcher.deposit(stake_amount);

    // test stake of owner
    let stake = staking_dispatcher.stake(owner);
    assert_eq!(stake, stake_amount);

    // test total stake
    let total_stake = staking_dispatcher.total_stake();
    assert_eq!(total_stake, stake_amount);
}


#[test]
#[available_gas(670)]
#[feature("safe_dispatcher")]
fn stake_with_no_allowance() {
    let token_address = utility::deploy_contract("ZeppelinToken", token_params());

    let staking_address = utility::deploy_contract("SimpleStaking", staking_params(token_address));
    let staking_dispatcher = ISimpleStakingSafeDispatcher { contract_address: staking_address };

    let owner = token_owner();

    // deposit tokens into the staking contract
    let stake_amount = 42_u256;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    match staking_dispatcher.deposit(stake_amount) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'STAKING: Approve stake first.', *panic_data.at(0));
        }
    };
}

#[test]
#[available_gas(900)]
fn withdraw_some_stake() {
    let token_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address: token_address };

    let staking_address = utility::deploy_contract("SimpleStaking", staking_params(token_address));
    let staking_dispatcher = ISimpleStakingDispatcher { contract_address: staking_address };

    let owner = token_owner();

    // approve the staking contract to spend tokens of owner
    let approval_amount = 42_u256;
    cheat_caller_address(token_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.approve(staking_address, approval_amount);

    // deposit tokens into the staking contract
    let stake_amount = approval_amount;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    staking_dispatcher.deposit(stake_amount);

    // withdraw some of the stake
    let withdraw_amount = 10_u256;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    staking_dispatcher.withdraw(withdraw_amount);

    // test remaining stake
    let stake = staking_dispatcher.stake(owner);
    assert_eq!(stake, stake_amount - withdraw_amount);

    // test total stake
    let total_stake = staking_dispatcher.total_stake();
    assert_eq!(total_stake, stake_amount - withdraw_amount);

    // test owner tokens
    let owner_tokens = token_dispatcher.balance_of(owner);
    assert_eq!(owner_tokens, TOKEN_SUPPLY - stake_amount + withdraw_amount);
}

#[test]
#[available_gas(710)]
fn withdraw_all_stake() {
    let token_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address: token_address };

    let staking_address = utility::deploy_contract("SimpleStaking", staking_params(token_address));
    let staking_dispatcher = ISimpleStakingDispatcher { contract_address: staking_address };

    let owner = token_owner();

    // approve the staking contract to spend tokens of owner
    let approval_amount = 42_u256;
    cheat_caller_address(token_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.approve(staking_address, approval_amount);

    // deposit tokens into the staking contract
    let stake_amount = approval_amount;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    staking_dispatcher.deposit(stake_amount);

    // withdraw entire stake
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    staking_dispatcher.withdraw_all();

    // test remaining stake
    let stake = staking_dispatcher.stake(owner);
    assert_eq!(stake, 0_u256);

    // test total stake
    let total_stake = staking_dispatcher.total_stake();
    assert_eq!(total_stake, 0_u256);

    // test owner tokens
    let owner_tokens = token_dispatcher.balance_of(owner);
    assert_eq!(owner_tokens, TOKEN_SUPPLY);
}

#[test]
#[available_gas(880)]
#[feature("safe_dispatcher")]
fn withdraw_too_much_stake() {
    let token_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address: token_address };

    let staking_address = utility::deploy_contract("SimpleStaking", staking_params(token_address));
    let staking_dispatcher = ISimpleStakingSafeDispatcher { contract_address: staking_address };

    let owner = token_owner();

    // approve the staking contract to spend tokens of owner
    let approval_amount = 42_u256;
    cheat_caller_address(token_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.approve(staking_address, approval_amount);

    // deposit tokens into the staking contract
    let stake_amount = approval_amount;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    staking_dispatcher.deposit(stake_amount).unwrap();

    // withdraw more than staked
    let withdraw_amount = stake_amount + 1_u256;
    cheat_caller_address(staking_address, owner, CheatSpan::TargetCalls(1));
    match staking_dispatcher.withdraw(withdraw_amount) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'STAKING: Withdrawl to big.', *panic_data.at(0));
        }
    }
}

pub fn staking_params(token_address: starknet::ContractAddress) -> Array<felt252> {
    let mut calldata = array![];
    // token address
    calldata.append(token_address.into());

    calldata
}
