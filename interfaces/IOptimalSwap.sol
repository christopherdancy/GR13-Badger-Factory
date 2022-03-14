pragma solidity ^0.8.0;


interface IOptimalSwap{
    /// @dev View function for testing the routing of the strategy
    function findOptimalSwap(address tokenIn, address tokenOut, uint256 amountIn) external view returns (string memory, uint256 amount);
}