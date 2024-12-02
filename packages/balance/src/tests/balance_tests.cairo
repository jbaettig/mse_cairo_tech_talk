use balance::simple_balance::ISimpleBalanceDispatcher;
use balance::simple_balance::ISimpleBalanceDispatcherTrait;
use balance::simple_balance::ISimpleBalanceSafeDispatcher;
use balance::simple_balance::ISimpleBalanceSafeDispatcherTrait;

#[test]
#[available_gas(240)]
fn test_increase_balance() {
    let contract_address = utility::deploy_contract("SimpleBalance", balance_params());
    let balance_dispatcher = ISimpleBalanceDispatcher { contract_address };

    let balance_before = balance_dispatcher.get_balance();
    assert_eq!(balance_before, 0, "Invalid balance");

    balance_dispatcher.increase_balance(42);

    let balance_after = balance_dispatcher.get_balance();
    assert_eq!(balance_after, 42, "Invalid balance");
}

#[test]
#[available_gas(110)]
#[should_panic(expected: ('Balance: Amount cannot be 0.',))]
fn test_increase_balance_with_zero() {
    let contract_address = utility::deploy_contract("SimpleBalance", balance_params());
    let balance_dispatcher = ISimpleBalanceDispatcher { contract_address };

    let balance_before = balance_dispatcher.get_balance();
    assert_eq!(balance_before, 0, "Invalid balance");

    // should fail
    balance_dispatcher.increase_balance(0);
}

#[test]
#[available_gas(180)]
#[feature("safe_dispatcher")]
fn test_increase_balance_with_zero_safe() {
    let contract_address = utility::deploy_contract("SimpleBalance", balance_params());

    let balance_dispatcher = ISimpleBalanceSafeDispatcher { contract_address };

    let balance_before = balance_dispatcher.get_balance().unwrap();
    assert(balance_before == 0, 'Invalid balance');

    match balance_dispatcher.increase_balance(0) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Balance: Amount cannot be 0.', *panic_data.at(0));
        }
    };
}

fn owner() -> core::starknet::ContractAddress {
    core::starknet::contract_address_const::<128>()
}

fn balance_params() -> Array<felt252> {
    let mut calldata = array![];
    // owner address
    calldata.append(owner().into());

    calldata
}
