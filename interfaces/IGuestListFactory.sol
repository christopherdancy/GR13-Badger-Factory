// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";
import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";
import "../interfaces/IOptimalSwap.sol";
import "../interfaces/ILPSwap.sol";
import "../interfaces/IUniswapV2Pair.sol";

interface IGuestListFactory {
    error AddressZero();
    error UintZero();
    error Bytes32Zero();
    
    event GuestListCreated(
        address guestlistImpl_,
        ITestVipCappedGuestListBbtcUpgradeable clone,
        address wrapper_,
        address newOwner_,
        uint256 userCap_,
        uint256 totalCap_,
        bytes32 guestRoot_
    );

    function createGuestListUnderlyingToken(
        IOptimalSwap optimalSwap_, 
        address guestlistImpl_,
        address usdDenomToken_,
        address wrapper_,
        address newOwner_,
        uint256 userCapUSD_,
        uint256 totalCapUSD_,
        bytes32 guestRoot_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone);

    function createGuestListLpToken(
        ILPSwap lpSwap_,
        IOptimalSwap optimalSwap_,
        address weth_,
        address guestlistImpl_,
        address usdDenomToken_,
        address wrapper_,
        address newOwner_,
        uint256 userCapUSD_,
        uint256 totalCapUSD_,
        bytes32 guestRoot_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone);
}
