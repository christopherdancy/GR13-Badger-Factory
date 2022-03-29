//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;
import "./swaps/IUniswapV2Pair.sol";
import "./swaps/IUniswapRouterV2.sol";

interface ILPSwap {
    event Price(
        uint256 indexed price,
        uint256 r0,
        uint256 LPWeth,
        uint256 totalSupply,
        uint256 sqrtK,
        uint256 px0,
        uint256 px1
    );
    /// @dev View function for finding LP swap
    /// @param pair Uniswap Pair Address
    /// @param weth Weth Address
    /// @param usdDenomToken Address of the stable coin 
    /// @param router Uniswap router Address
    /// @return lpUSD lpToken denom in USD
    function findLPSwap(
        IUniswapV2Pair pair,
        address weth,
        address usdDenomToken,
        IUniswapRouterV2 router
    ) external returns (uint256 lpUSD);
}
