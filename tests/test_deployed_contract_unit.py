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
from scripts.constants import USER_CAP, TOTAL_CAP, MERCKLE_ROOT, PROOF


def test_user_cap():
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
    print(f"userDepositCap of deployed contract: {deployed_contract.userDepositCap()}")
    assert deployed_contract.userDepositCap() == USER_CAP


def test_total_cap():
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
    print(
        f"TotalDepositCap of deployed contract: {deployed_contract.totalDepositCap()}"
    )
    assert deployed_contract.totalDepositCap() == TOTAL_CAP


def test_merckle_root():
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
    print(f"MerckleRoot of deployed contract: {deployed_contract.guestRoot()}")
    assert deployed_contract.guestRoot() == MERCKLE_ROOT


def test_wrapper():
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
    print(f"Wrapper of deployed contract: {deployed_contract.wrapper()}")
    assert deployed_contract.wrapper() == wrapper
