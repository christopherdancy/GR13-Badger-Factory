from brownie import (
    Contract,
    network,
    config,
    accounts,
    interface,
    TestToken,
    GuestListFactory,
    TestVipCappedGuestListBbtcUpgradeable,
)


FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account(index=None, id=None):

    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]

    return accounts.add(config["wallets"]["from_key"])


def get_token_address():
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or FORKED_LOCAL_ENVIRONMENTS
    ):
        return deploy_token().address
    else:
        # return config["networks"][network.show_active()]["test_token"]
        return deploy_token().address


def deploy_token():
    print("deploying token")
    account = get_account()
    token = TestToken.deploy(
        420_000_000_000_000_000_000_000,
        {"from": account},
    )
    print(f"token deployed at: {token.address}")
    return token


contract_to_mock = {
    "guest_list_factory": GuestListFactory,
    "guest_list_contract": TestVipCappedGuestListBbtcUpgradeable,
}


def get_contract(contract_address):
    contract_type = TestVipCappedGuestListBbtcUpgradeable
    contract = Contract.from_abi(
        contract_type._name, contract_address, contract_type.abi
    )
    return contract


def get_contract_factory(contract_address):
    contract_type = GuestListFactory
    contract = Contract.from_abi(
        contract_type._name, contract_address, contract_type.abi
    )
    return contract
