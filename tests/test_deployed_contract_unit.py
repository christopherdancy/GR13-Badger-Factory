from brownie import (
    Contract,
    accounts,
    network,
    config,
    TestVipCappedGuestListBbtcUpgradeable,
    GuestListFactory,
)

from scripts.deploy import deploy_contract, get_paramaters
import pytest
from scripts.constants import (
    USER_CAP,
    TOTAL_CAP,
    MERCKLE_ROOT,
    PROOF,
    USDT_TOKEN_ADDRESS_ETH,
    LINK_TOKEN_ADDRESS_ETH,
)


def test_user_cap():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract(
        contract_factory,
        base_contract,
        usdt_token,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(f"userDepositCap of deployed contract: {deployed_contract.userDepositCap()}")
    assert deployed_contract.userDepositCap() > 0


def test_total_cap():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract(
        contract_factory,
        base_contract,
        usdt_token,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(
        f"TotalDepositCap of deployed contract: {deployed_contract.totalDepositCap()}"
    )
    assert deployed_contract.totalDepositCap() > 0


def test_merckle_root():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract(
        contract_factory,
        base_contract,
        usdt_token,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(f"MerckleRoot of deployed contract: {deployed_contract.guestRoot()}")
    assert deployed_contract.guestRoot() == "0x" + MERCKLE_ROOT


def test_wrapper():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract(
        contract_factory,
        base_contract,
        usdt_token,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(f"Wrapper of deployed contract: {deployed_contract.wrapper()}")
    assert deployed_contract.wrapper() == wrapper


def test_OptimalSwap():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract(
        contract_factory,
        base_contract,
        usdt_token,
        wrapper,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(f"Wrapper of deployed contract: {deployed_contract.wrapper()}")
    assert deployed_contract.wrapper() == wrapper
