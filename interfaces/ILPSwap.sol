pragma solidity ^0.8.0;
import "./IUniswapV2Pair.sol";
import "./IUniswapRouterV2.sol";

interface ILPSwap {
    function findLPSwap(IUniswapV2Pair pair, IUniswapRouterV2 router, address weth, address usdDenomToken) external returns(uint);
}