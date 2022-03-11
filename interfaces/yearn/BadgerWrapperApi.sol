// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../erc20/IERC20.sol";

interface BadgerWrapperAPI is IERC20 {
    function token() external view returns (address);

    function pricePerShare() external view returns (uint256);

    function totalWrapperBalance(address account)
        external
        view
        returns (uint256);

    function totalVaultBalance(address account) external view returns (uint256);
}
