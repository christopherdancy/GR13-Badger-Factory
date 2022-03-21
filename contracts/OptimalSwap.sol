//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;
import "../interfaces/IBaseV1Router01.sol";
import "../interfaces/ICurveRouter.sol";
import "../interfaces/IUniswapRouterV2.sol";

contract OptimalSwap {
    ICurveRouter immutable public CURVE_ROUTER;
    IUniswapRouterV2 immutable public UNI_ROUTER;

    constructor(ICurveRouter curveRouter, IUniswapRouterV2 uniRouter) {
        CURVE_ROUTER = curveRouter;
        UNI_ROUTER = uniRouter;
    }

    /// @dev View function for testing the routing of the strategy
    function findOptimalSwap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn
    ) external view returns (string memory, uint256 amount) {
        // Check Curve
        (, uint256 curveQuote) = CURVE_ROUTER.get_best_rate(
            tokenIn,
            tokenOut,
            amountIn
        );

        uint256 uniQuote; // 0 by default

        // Check uni (Can Revert)
        address[] memory path = new address[](2);
        path[0] = address(tokenIn);
        path[1] = address(tokenOut);

        try UNI_ROUTER.getAmountsOut(amountIn, path) returns (
            uint256[] memory uniAmounts
        ) {
            uniQuote = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
        } catch (bytes memory) {
            // We ignore as it means it's zero
        }

        // Solidly service seems to not be longer available by april 3 on FTM and is not available on Eth BC
        // As we want a cross chain deployment, we decide to work with curve and uni/spooky only
        // uni will be the default case
        if (curveQuote > uniQuote) {
            // Curve is greater than both
            return ("curve", curveQuote);
        } else {
            // uni is best
            return ("uni", uniQuote);
        }
    }
}
