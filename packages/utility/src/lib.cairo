use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

pub const TOKEN_NAME: felt252 = 'Zeppelin';
pub const TOKEN_SYMBOL: felt252 = 'ZPL';
pub const TOKEN_SUPPLY: u256 = 1_000_000_000_u256 * 1_000_000_000_000_000_000_u256;

/// deploy a given contract by it's name
pub fn deploy_contract(name: ByteArray, calldata: Array::<felt252>) -> starknet::ContractAddress {
    let contract = declare(name).unwrap().contract_class();

    match contract.deploy(@calldata) {
        Result::Ok((contract_address, _)) => contract_address,
        Result::Err(panic_data) => panic(panic_data),
    }
}

pub fn token_params() -> Array<felt252> {
    let mut calldata = array![];
    // token name
    calldata.append(0); // nof full felts in array
    calldata.append(TOKEN_NAME);
    calldata.append(8); // nof bytes in last element

    // token symbol
    calldata.append(0); // nof full felts in array
    calldata.append(TOKEN_SYMBOL);
    calldata.append(3); // nof bytes in last element

    // token owner
    calldata.append(token_owner().into());

    // token supply
    calldata.append(TOKEN_SUPPLY.low.into());
    calldata.append(TOKEN_SUPPLY.high.into());

    calldata
}

pub fn token_owner() -> starknet::ContractAddress {
    starknet::contract_address_const::<1>()
}
