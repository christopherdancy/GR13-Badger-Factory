//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;
import "./swaps/ICurveRouter.sol";
import "./swaps/IUniswapRouterV2.sol";

interface IOptimalSwap{
    function CURVE_ROUTER() external view returns(ICurveRouter);
    function UNI_ROUTER() external view returns(IUniswapRouterV2);
    /// @dev View function for testing the routing of the strategy
    /// @param tokenIn Token user wants to exchange
    /// @param tokenOut Token user is exchanging for
    /// @param amountIn Total Tokens user wants to exchange
    function findOptimalSwap(address tokenIn, address tokenOut, uint256 amountIn) external view returns (string memory, uint256 amount);
}