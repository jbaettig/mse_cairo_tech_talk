use openzeppelin_token::erc20::interface::IERC20MetadataDispatcher;
use openzeppelin_token::erc20::interface::IERC20MetadataDispatcherTrait;
use openzeppelin_token::erc20::interface::IERC20Dispatcher;
use openzeppelin_token::erc20::interface::IERC20DispatcherTrait;
use openzeppelin_token::erc20::interface::IERC20SafeDispatcher;
use openzeppelin_token::erc20::interface::IERC20SafeDispatcherTrait;

use snforge_std::{cheat_caller_address, CheatSpan};

use utility::{token_params, token_owner, TOKEN_SUPPLY};

#[test]
#[available_gas(500)]
fn test_metadata() {
    let contract_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20MetadataDispatcher { contract_address };

    // test name
    let name = token_dispatcher.name();
    assert_eq!(name, "Zeppelin");

    // test symbol
    let symbol = token_dispatcher.symbol();
    assert_eq!(symbol, "ZPL");

    // test decimals
    let decimals = token_dispatcher.decimals();
    assert_eq!(decimals, 18_u8);
}

#[test]
#[available_gas(500)]
fn test_initial_supply() {
    let contract_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address };

    // test total supply
    let supply = token_dispatcher.total_supply();
    assert_eq!(supply, TOKEN_SUPPLY);
}

#[test]
#[available_gas(570)]
fn test_transfer() {
    let contract_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address };

    let owner = token_owner();
    let recipient = starknet::contract_address_const::<42>();

    // transfer tokens
    let transfer_amount = 128_u256;
    cheat_caller_address(contract_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.transfer(recipient, transfer_amount);

    // test balance of owner
    let owner_balance = token_dispatcher.balance_of(owner);
    assert_eq!(owner_balance, TOKEN_SUPPLY - transfer_amount);

    // test balance of recipient
    let recipient_balance = token_dispatcher.balance_of(recipient);
    assert_eq!(recipient_balance, transfer_amount);
}

#[test]
#[available_gas(570)]
fn test_approve() {
    let contract_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address };

    let owner = token_owner();
    let spender = starknet::contract_address_const::<42>();

    // approve tokens
    let approval_amount = 42_u256;
    cheat_caller_address(contract_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.approve(spender, approval_amount);

    // test allowance of spender
    let allowance = token_dispatcher.allowance(owner, spender);
    assert_eq!(allowance, approval_amount);
}

#[test]
#[available_gas(650)]
fn test_transfer_from() {
    let contract_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20Dispatcher { contract_address };

    let owner = token_owner();
    let spender = starknet::contract_address_const::<42>();
    let recipient = starknet::contract_address_const::<84>();

    // approve tokens
    let approval_amount = 42_u256;
    cheat_caller_address(contract_address, owner, CheatSpan::TargetCalls(1));
    token_dispatcher.approve(spender, approval_amount);

    // spend all tokens but one
    let transfer_amount = approval_amount - 1;
    cheat_caller_address(contract_address, spender, CheatSpan::TargetCalls(1));
    token_dispatcher.transfer_from(owner, recipient, transfer_amount);

    // test remaining allowance of spender
    let allowance = token_dispatcher.allowance(owner, spender);
    assert_eq!(allowance, 1_u256);

    // test balance of owner
    let owner_balance = token_dispatcher.balance_of(owner);
    assert_eq!(owner_balance, TOKEN_SUPPLY - transfer_amount);

    // test balance of spender
    let spender_balance = token_dispatcher.balance_of(spender);
    assert_eq!(spender_balance, 0);

    // test balance of recipient
    let recipient_balance = token_dispatcher.balance_of(recipient);
    assert_eq!(recipient_balance, transfer_amount);
}

#[test]
#[available_gas(500)]
#[feature("safe_dispatcher")]
fn test_transfer_from_not_approved() {
    let contract_address = utility::deploy_contract("ZeppelinToken", token_params());
    let token_dispatcher = IERC20SafeDispatcher { contract_address };

    let owner = token_owner();
    let spender = starknet::contract_address_const::<42>();
    let recipient = starknet::contract_address_const::<84>();

    // transfer tokens without approval
    let transfer_amount = 42;
    cheat_caller_address(contract_address, spender, CheatSpan::TargetCalls(1));
    match token_dispatcher.transfer_from(owner, recipient, transfer_amount) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'ERC20: insufficient allowance', *panic_data.at(0));
        }
    };
}
