from brownie import Contract
import brownie
from web3 import Web3

# For these tests we have used USDT for stable coin,
# LINK for wrapper and a RADIX/USDC contract pool for LP Token address

# User deposit cap in dollars
USER_CAP = 100000000000000000000000000000000000000
TOTAL_CAP = 200000000000000000000000000000000000000
# Initial MERCKLE_ROOT = "0x1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a"
PROOF = "0x1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a"
MERCKLE_ROOT = "1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a"


# Address for ETH network
# Address on ether not found
UNISWAP_ROUTER_ADDRESS_ETH = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
# Curve / Doesn't revert on failure
CURVE_ROUTER_ADDRESS_ETH = "0xD1602F68CC7C4c7B59D686243EA35a9C73B0c6a2"

# Address for FTM network
# Spookyswap, reverts on failure
SPOOKY_ROUTER_ADDRESS_FTM = "0xF491e7B69E4244ad4002BC14e878a34207E38c29"
# Curve / Doesn't revert on failure
CURVE_ROUTER_ADDRESS_FTM = "0x74E25054e98fd3FCd4bbB13A962B43E49098586f"


LINK_TOKEN_ADDRESS_ETH = "0x514910771af9ca656af840dff83e8264ecf986ca"
USDT_TOKEN_ADDRESS_ETH = "0xdac17f958d2ee523a2206206994597c13d831ec7"

LP_TOKEN_ADDRESS_ETH = "0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc"
LP_RADIX_USDC_ETH = "0x6f118ecebc31a5ffe49b87c47ea80f93a2af0a8a"
WETH_TOKEN_ADDRESS_ETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"


def get_curve_router_address_eth():
    provider = Contract("0x0000000022D53366457F9d5E68Ec105046FC4383")
    return provider.get_address(2)
