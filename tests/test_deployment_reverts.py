from brownie import (
    Contract,
    accounts,
    network,
    config,
    TestVipCappedGuestListBbtcUpgradeable,
    GuestListFactory,
    exceptions,
)
import brownie

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


def test_deployment_reverts_user_cap():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    USER_CAP_ZERO = 0
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract(
            contract_factory,
            base_contract,
            usdt_token,
            wrapper,
            account,
            USER_CAP_ZERO,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_user_cap_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    USER_CAP_ZERO = 0
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract_lp(
            contract_factory,
            base_contract,
            usdt_token,
            LP_RADIX_USDC_ETH,
            account,
            USER_CAP_ZERO,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_total_cap():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    TOTAL_CAP_ZERO = 0
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract(
            contract_factory,
            base_contract,
            usdt_token,
            wrapper,
            account,
            USER_CAP,
            TOTAL_CAP_ZERO,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_total_cap_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    TOTAL_CAP_ZERO = 0
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract_lp(
            contract_factory,
            base_contract,
            usdt_token,
            LP_RADIX_USDC_ETH,
            account,
            USER_CAP,
            TOTAL_CAP_ZERO,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_base_contract():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract(
            contract_factory,
            brownie.ZERO_ADDRESS,
            usdt_token,
            wrapper,
            account,
            USER_CAP,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_base_contract_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract_lp(
            contract_factory,
            brownie.ZERO_ADDRESS,
            usdt_token,
            LP_RADIX_USDC_ETH,
            account,
            USER_CAP,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_usdt_token():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract(
            contract_factory,
            base_contract,
            brownie.ZERO_ADDRESS,
            wrapper,
            account,
            USER_CAP,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_usdt_token_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract_lp(
            contract_factory,
            base_contract,
            brownie.ZERO_ADDRESS,
            LP_RADIX_USDC_ETH,
            account,
            USER_CAP,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_wrapper():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract(
            contract_factory,
            base_contract,
            usdt_token,
            brownie.ZERO_ADDRESS,
            account,
            USER_CAP,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_wrapper_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract_lp(
            contract_factory,
            base_contract,
            usdt_token,
            brownie.ZERO_ADDRESS,
            account,
            USER_CAP,
            TOTAL_CAP,
            MERCKLE_ROOT,
        )


def test_deployment_reverts_merckle_root():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract(
            contract_factory,
            base_contract,
            usdt_token,
            wrapper,
            account,
            USER_CAP,
            TOTAL_CAP,
            "",
        )


def test_deployment_reverts_merckle_root_lp():
    contract_factory, base_contract, usdt_token, wrapper, account = get_paramaters()
    with pytest.raises(exceptions.VirtualMachineError):
        deployed_contract = deploy_contract_lp(
            contract_factory,
            base_contract,
            usdt_token,
            LP_RADIX_USDC_ETH,
            account,
            USER_CAP,
            TOTAL_CAP,
            "",
        )
