from brownie import (
    Contract,
    accounts,
    network,
    config,
    TestVipCappedGuestListBbtcUpgradeable,
    GuestListFactory,
)
from eth_account import Account
from scripts.helpfulscripts import (
    get_account,
    get_token_address,
    get_contract,
    get_contract_factory,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    FORKED_LOCAL_ENVIRONMENTS,
)
import time
from Crypto.Hash import keccak
from scripts.constants import USER_CAP, TOTAL_CAP, PROOF, MERCKLE_ROOT


def main():
    check_merckle_root()


def check_merckle_root():
    merckle_root = MERCKLE_ROOT.encode(encoding="UTF-8")
    contract_factory, base_contract, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract(
        contract_factory,
        base_contract,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )

    print(f"guestRoot of deployed contract: {deployed_contract.guestRoot()}")
    print(f"MerckleRoot in script: {MERCKLE_ROOT}")

    # byte32 = bytes(PROOF, "utf-8")
    # tx = deployed_contract.proveInvitation(account.address, [byte32], {"from": account})
    # tx.wait(1)
    # print(f"guests of the contract: {deployed_contract.guests()}")

    ###


def deploy_base_contract():
    # we need a deployed contract to clone it with the factory
    account = get_account()
    contract_address = TestVipCappedGuestListBbtcUpgradeable.deploy(
        {"from": account}
    ).address
    print(f"base contract address{contract_address}")
    return contract_address


def deploy_factory():
    # deploy the contract factory
    account = get_account()
    contract_factory = GuestListFactory.deploy({"from": account})
    time.sleep(15)
    print(f"factory contract address{contract_factory.address}")
    return contract_factory


def deploy_contract(
    contract_factory,
    contract_address_to_clone,
    wrapper,
    address_new_owner,
    user_cap,
    total_cap,
    merckle_root,
):
    # deploy cloned guestList contract
    account = get_account()
    tx_create_guest_list = contract_factory.createGuestList(
        contract_address_to_clone,
        wrapper,
        address_new_owner,
        user_cap,
        total_cap,
        merckle_root,
        {"from": account},
    )
    tx_create_guest_list.wait(1)
    clone_address = tx_create_guest_list.events[-1]["clone"]
    print(f"clone address {clone_address}")
    contract = get_contract(clone_address)

    return contract


def get_paramaters():
    # Deploy contracts or get the contract on the blockchain depending of the network
    if (
        network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        and network.show_active() not in FORKED_LOCAL_ENVIRONMENTS
    ):
        print(f"actual network: {network.show_active()}")
        account = get_account()
        wrapper = config["networks"][network.show_active()]["test_token"]
        base_contract = config["networks"][network.show_active()][
            "guest_list_base_contract"
        ]
        contract_factory = get_contract_factory(
            config["networks"][network.show_active()]["guest_list_factory"]
        )
        return contract_factory, base_contract, wrapper, account

    else:
        account = get_account()
        base_contract = deploy_base_contract()
        contract_factory = deploy_factory()
        wrapper = get_token_address()
        return contract_factory, base_contract, wrapper, account
