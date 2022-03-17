pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./utils/HomoraMath.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "../interfaces/IUniswapRouterV2.sol";

contract LPSwap {
    using SafeMath for uint256;
    using HomoraMath for uint256;

    function findLPSwap(
        IUniswapV2Pair pair,
        IUniswapRouterV2 router,
        address weth,
        address usdDenomToken
    ) external returns (uint256) {
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();
        (uint256 r0, uint256 r1, ) = IUniswapV2Pair(pair).getReserves();
        uint256 sqrtK = HomoraMath.sqrt(r0.mul(r1)).fdiv(totalSupply); // in 2**112
        uint256 px0; // 0 by default
        {
            // Check uni (Can Revert)
            address[] memory path0 = new address[](2);
            path0[0] = address(token0);
            path0[1] = address(weth);

            try router.getAmountsOut(1, path0) returns (
                uint256[] memory uniAmounts
            ) {
                px0 = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
            } catch (bytes memory) {
                // We ignore as it means it's zero
            }
        }

        uint256 px1; // 0 by default
        {
            // Check uni (Can Revert)
            address[] memory path1 = new address[](2);
            path1[0] = address(token1);
            path1[1] = address(weth);

            try router.getAmountsOut(1, path1) returns (
                uint256[] memory uniAmounts
            ) {
                px1 = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
            } catch (bytes memory) {
                // We ignore as it means it's zero
            }
        }

        // fair token0 amt: sqrtK * sqrt(px1/px0)
        // fair token1 amt: sqrtK * sqrt(px0/px1)
        // fair lp price = 2 * sqrt(px0 * px1)
        // split into 2 sqrts multiplication to prevent uint overflow (note the 2**112)
        uint256 LPWeth = sqrtK
            .mul(2)
            .mul(HomoraMath.sqrt(px0))
            .div(2**56)
            .mul(HomoraMath.sqrt(px1))
            .div(2**56);
        uint256 lpUSD; // 0 by default
        {
            // Check uni (Can Revert)
            address[] memory pathlp = new address[](2);
            pathlp[0] = address(weth);
            pathlp[1] = address(usdDenomToken);

            try router.getAmountsOut(LPWeth, pathlp) returns (
                uint256[] memory uniAmounts
            ) {
                px1 = uniAmounts[uniAmounts.length - 1]; // Last one is the outToken
            } catch (bytes memory) {
                // We ignore as it means it's zero
            }
        }
        return lpUSD;
    }
}
