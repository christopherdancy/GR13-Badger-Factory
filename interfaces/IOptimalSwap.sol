pragma solidity ^0.8.0;
import "./ICurveRouter.sol";
import "./IUniswapRouterV2.sol";

interface IOptimalSwap{
    function CURVE_ROUTER() external view returns(ICurveRouter);
    function UNI_ROUTER() external view returns(IUniswapRouterV2);
    /// @dev View function for testing the routing of the strategy
    function findOptimalSwap(address tokenIn, address tokenOut, uint256 amountIn) external view returns (string memory, uint256 amount);
}