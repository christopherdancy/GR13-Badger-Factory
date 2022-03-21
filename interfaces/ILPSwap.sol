//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;
import "./IUniswapV2Pair.sol";
import "./IUniswapRouterV2.sol";

interface ILPSwap {
    function findLPSwap(
        IUniswapV2Pair pair,
        address weth,
        address usdDenomToken,
        IUniswapRouterV2 router
    ) external returns (uint256 lpUSD);
}
