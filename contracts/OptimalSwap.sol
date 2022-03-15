pragma solidity ^0.8.0;
import "../interfaces/IBaseV1Router01.sol";
import "../interfaces/ICurveRouter.sol";
import "../interfaces/IUniswapRouterV2.sol";


contract OptimalSwap{
    IBaseV1Router01 immutable SOLIDLY_ROUTER;
    ICurveRouter immutable CURVE_ROUTER;
    IUniswapRouterV2 immutable UNI_ROUTER;
    
    constructor(IBaseV1Router01 solidlyRouter, ICurveRouter curveRouter, IUniswapRouterV2 uniRouter) {
        SOLIDLY_ROUTER = solidlyRouter;
        CURVE_ROUTER = curveRouter;
        UNI_ROUTER = uniRouter;
    }
    
    /// @dev View function for testing the routing of the strategy
    function findOptimalSwap(address tokenIn, address tokenOut, uint256 amountIn) external view returns (string memory, uint256 amount) {
        // Check Solidly
        (uint256 solidlyQuote, bool stable) = SOLIDLY_ROUTER.getAmountOut(amountIn, tokenIn, tokenOut);

        // Check Curve
        (, uint256 curveQuote) = CURVE_ROUTER.get_best_rate(tokenIn, tokenOut, amountIn);

        uint256 uniQuote; // 0 by default

        // Check uni (Can Revert)
        address[] memory path = new address[](2);
        path[0] = address(tokenIn);
        path[1] = address(tokenOut);

        try UNI_ROUTER.getAmountsOut(amountIn, path) returns (uint256[] memory uniAmounts) {
            uniQuote = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
        } catch (bytes memory) {
            // We ignore as it means it's zero
        }

        
        // On average, we expect Solidly and Curve to offer better slippage
        // uni will be the default case
        if(solidlyQuote > uniQuote) {
            // Either SOLID or curve
            if(curveQuote > solidlyQuote) {
                // Curve
                return ("curve", curveQuote);
            } else {
                // Solid 
                return ("SOLID", solidlyQuote);
            }

        } else if (curveQuote > uniQuote) {
            // Curve is greater than both
            return ("curve", curveQuote);
        } else {
            // uni is best
            return ("uni", uniQuote);
        }
    }
}