from brownie import (
    Contract,
    accounts,
    network,
    config,
    TestVipCappedGuestListBbtcUpgradeable,
    GuestListFactory,
    interface,
    OptimalSwap,
)
from eth_account import Account
from scripts.helpfulscripts import (
    deploy_token,
    get_account,
    get_token_address,
    get_contract,
    get_contract_factory,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    FORKED_LOCAL_ENVIRONMENTS,
)
import time
from Crypto.Hash import keccak
from scripts.constants import (
    USER_CAP,
    TOTAL_CAP,
    PROOF,
    MERCKLE_ROOT,
    UNISWAP_ROUTER_ADDRESS_ETH,
    CURVE_ROUTER_ADDRESS_ETH,
    LINK_TOKEN_ADDRESS_ETH,
    USDT_TOKEN_ADDRESS_ETH,
    get_curve_router_address_eth,
)

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def main():
    pass


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
    # get the routers to create the factory
    curve_router = interface.ICurveRouter(CURVE_ROUTER_ADDRESS_ETH)
    unispooky_router = interface.IUniswapRouterV2(UNISWAP_ROUTER_ADDRESS_ETH)
    optimalSwap = OptimalSwap.deploy(curve_router, unispooky_router, {"from": account})

    contract_factory = GuestListFactory.deploy(optimalSwap, {"from": account})
    time.sleep(15)
    print(f"factory contract address{contract_factory.address}")
    return contract_factory


def deploy_contract(
    contract_factory,
    contract_address_to_clone,
    usd_token_address,
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
        usd_token_address,
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
        usdt_contract = config["networks"][network.show_active()]["usdt_token"]
        wrapper = config["networks"][network.show_active()]["link_token"]
        base_contract = config["networks"][network.show_active()][
            "guest_list_base_contract"
        ]
        contract_factory = get_contract_factory(
            config["networks"][network.show_active()]["guest_list_factory"]
        )
        return contract_factory, base_contract, usdt_contract, wrapper, account

    elif network.show_active() in FORKED_LOCAL_ENVIRONMENTS:
        account = get_account()
        base_contract = deploy_base_contract()
        contract_factory = deploy_factory()
        usdt_contract = USDT_TOKEN_ADDRESS_ETH
        wrapper = LINK_TOKEN_ADDRESS_ETH
        return contract_factory, base_contract, usdt_contract, wrapper, account
    else:
        account = get_account()
        base_contract = deploy_base_contract()
        contract_factory = deploy_factory()
        usdt_contract = get_token_address()
        wrapper = get_token_address()
        return contract_factory, base_contract, usdt_contract, wrapper, account


def print_user_cap():
    account = get_account()
    base_contract = deploy_base_contract()
    contract_factory = deploy_factory()
    wrapper = LINK_TOKEN_ADDRESS_ETH
    contract_deployed = deploy_contract(
        contract_factory,
        base_contract,
        USDT_TOKEN_ADDRESS_ETH,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(f"UserCap of deployed Contract: {contract_deployed.userDepositCap()}")
