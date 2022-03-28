from brownie import (
    Contract,
    accounts,
    network,
    config,
    TestVipCappedGuestListBbtcUpgradeable,
    GuestListFactory,
)
import brownie
from web3 import Web3

from scripts.deploy import deploy_contract, get_paramaters, deploy_contract_lp
import pytest
from scripts.constants import (
    USER_CAP,
    TOTAL_CAP,
    MERCKLE_ROOT,
    PROOF,
    USDT_TOKEN_ADDRESS_ETH,
    LINK_TOKEN_ADDRESS_ETH,
    LP_RADIX_USDC_ETH,
)


def test_deployment():
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
    assert deployed_contract.address != brownie.ZERO_ADDRESS


def test_deployment_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract_lp(
        contract_factory,
        base_contract,
        usdt_token,
        LP_RADIX_USDC_ETH,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    assert deployed_contract.address != brownie.ZERO_ADDRESS


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


def test_user_cap_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()

    deployed_contract = deploy_contract_lp(
        contract_factory,
        base_contract,
        usdt_token,
        LP_RADIX_USDC_ETH,
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


def test_total_cap_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract_lp(
        contract_factory,
        base_contract,
        usdt_token,
        LP_RADIX_USDC_ETH,
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


def test_merckle_root_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract_lp(
        contract_factory,
        base_contract,
        usdt_token,
        LP_RADIX_USDC_ETH,
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


def test_wrapper_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    deployed_contract = deploy_contract_lp(
        contract_factory,
        base_contract,
        usdt_token,
        LP_RADIX_USDC_ETH,
        account,
        USER_CAP,
        TOTAL_CAP,
        MERCKLE_ROOT,
    )
    print(f"Wrapper of deployed contract: {deployed_contract.wrapper()}")
    assert deployed_contract.wrapper() == LP_RADIX_USDC_ETH
