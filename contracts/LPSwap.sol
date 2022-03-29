//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./utils/HomoraMath.sol";
import "../interfaces/ILPSwap.sol";
import "../interfaces/swaps/IUniswapV2Pair.sol";

contract LPSwap is ILPSwap {
    using SafeMath for uint256;
    using HomoraMath for uint256;

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
    ) external returns (uint256 lpUSD) {
        // Init Uniswap Reserves
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();
        (uint256 r0, uint256 r1, uint256 timestamp) = IUniswapV2Pair(pair)
            .getReserves();
        // Calulcate K
        uint256 sqrtK = HomoraMath.sqrt(r0.mul(r1)).fdiv(totalSupply); // in 2**112
        // Reserves value in ETH
        uint256 px0 = _checkUni(token0, weth, 1, router);
        uint256 px1 = _checkUni(token1, weth, 1, router);
        // fair token0 amt: sqrtK * sqrt(px1/px0)
        // fair token1 amt: sqrtK * sqrt(px0/px1)
        // fair lp price = 2 * sqrt(px0 * px1)
        // split into 2 sqrts multiplication to prevent uint overflow (note the 2**112)
        // LP value in  ETH
        uint256 LPWeth = sqrtK
            .mul(2)
            .mul(HomoraMath.sqrt(px0))
            .div(2**56)
            .mul(HomoraMath.sqrt(px1))
            .div(2**56);
        // Lp(each) value in USD
        lpUSD = _checkUni(weth, usdDenomToken, LPWeth, router);
        emit Price(lpUSD, r0, LPWeth, totalSupply, sqrtK, px0, px1);
    }

    /// @dev View function for testing the routing of the strategy
    /// @param tokenIn Token user wants to exchange
    /// @param weth Weth Address    
    /// @param amountIn Total Tokens user wants to exchange
    /// @param router Uniswap router Address
    /// @return px Price Exchange
    function _checkUni(
        address tokenIn,
        address weth,
        uint256 amountIn,
        IUniswapRouterV2 router
    ) internal returns (uint256 px) {
        // Check uni (Can Revert)
        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(tokenIn);

        try router.getAmountsOut(amountIn, path) returns (
            uint256[] memory uniAmounts
        ) {
            px = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
            if (px == 0) {
                address[] memory revertedpath = new address[](2);
                revertedpath[0] = address(tokenIn);
                revertedpath[1] = address(weth);
                try router.getAmountsOut(amountIn, revertedpath) returns (
                    uint256[] memory uniAmounts
                ) {
                    px = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
                } catch (bytes memory) {
                    // We ignore as it means it's zero
                }
            }
        } catch (bytes memory) {
            // We ignore as it means it's zero
        }
    }
}
