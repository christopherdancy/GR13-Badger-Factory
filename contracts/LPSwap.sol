//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./utils/HomoraMath.sol";
import "../interfaces/ILPSwap.sol";
import "../interfaces/IUniswapV2Pair.sol";

contract LPSwap is ILPSwap {
    using SafeMath for uint256;
    using HomoraMath for uint256;
    uint256 public reserve0;

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
        reserve0 = r0;
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
    }

    function _checkUni(
        address tokenIn,
        address weth,
        uint256 amountIn,
        IUniswapRouterV2 router
    ) internal returns (uint256 px) {
        // Check uni (Can Revert)
        address[] memory path = new address[](2);
        path[0] = address(tokenIn);
        path[1] = address(weth);

        try router.getAmountsOut(amountIn, path) returns (
            uint256[] memory uniAmounts
        ) {
            px = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
        } catch (bytes memory) {
            // We ignore as it means it's zero
        }
    }
}
