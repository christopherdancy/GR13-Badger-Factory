// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ITestVipCappedGuestListBbtcUpgradeable.sol";
import "./IOptimalSwap.sol";
import "./ILPSwap.sol";
import "./swaps/IUniswapV2Pair.sol";

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

    /// @notice Create a GuestList with an underlying token
    /// @dev Pass in USD Max - will be converted to total token max
    /// @param optimalSwap_ Optimal Swap Address
    /// @param guestlistImpl_ Guestlist Impl contract
    /// @param usdDenomToken_ USD Stable coin Address
    /// @param wrapper_ Token being capped
    /// @param newOwner_ GuestList contract Owner
    /// @param userCapUSD_ Total USD user cap
    /// @param totalCapUSD_ Total USD total cap
    /// @param guestRoot_ Guestlist Merkle Root
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

    /// @notice Create a GuestList with an LP token
    /// @dev Pass in USD Max - will be converted to total token max
    /// @param lpSwap_ LP Swap Address
    /// @param optimalSwap_ Optimal Swap Address
    /// @param weth_ Weth Token
    /// @param guestlistImpl_ Guestlist Impl contract
    /// @param usdDenomToken_ USD Stable coin Address
    /// @param wrapper_ Token being capped
    /// @param newOwner_ GuestList contract Owner
    /// @param userCapUSD_ Total USD user cap
    /// @param totalCapUSD_ Total USD total cap
    /// @param guestRoot_ Guestlist Merkle Root
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
