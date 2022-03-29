// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/proxy/ClonesUpgradeable.sol";
import "../interfaces/IGuestListFactory.sol";

contract GuestListFactory is IGuestListFactory {
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
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone) {
        // Safeguard Params
        if (userCapUSD_ == 0) revert UintZero();
        if (totalCapUSD_ == 0) revert UintZero();
        // Convert usd => token
        (, uint256 userWantCap_) = optimalSwap_.findOptimalSwap(
            usdDenomToken_,
            wrapper_,
            userCapUSD_
        );
        (, uint256 totalWantCap_) = optimalSwap_.findOptimalSwap(
            usdDenomToken_,
            wrapper_,
            totalCapUSD_
        );
        clone = _createGuestList(
            guestlistImpl_,
            wrapper_,
            newOwner_,
            userWantCap_,
            totalWantCap_,
            guestRoot_
        );
    }

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
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone) {
        // Safeguard Params
        if (weth_ == address(0)) revert AddressZero();
        if (userCapUSD_ == 0) revert UintZero();
        if (totalCapUSD_ == 0) revert UintZero();
        uint256 lpPrice = lpSwap_.findLPSwap(
            IUniswapV2Pair(wrapper_),
            weth_,
            usdDenomToken_,
            optimalSwap_.UNI_ROUTER()
        );
        // Convert lpUSD(each) = LP(total)
        // *Careful with percisions errors
        uint256 userWantCap_ = userCapUSD_ / lpPrice;
        uint256 totalWantCap_ = totalCapUSD_ / lpPrice;
        clone = _createGuestList(
            guestlistImpl_,
            wrapper_,
            newOwner_,
            userWantCap_,
            totalWantCap_,
            guestRoot_
        );
    }

    /// @dev Pass in USD Max - will be converted to total token max
    /// @param guestlistImpl_ Guestlist Impl contract
    /// @param wrapper_ Token being capped
    /// @param newOwner_ GuestList contract Owner
    /// @param userWantCap_ Total USD user cap
    /// @param totalWantCap_ Total USD total cap
    /// @param guestRoot_ Guestlist Merkle Root
    function _createGuestList(
        address guestlistImpl_,
        address wrapper_,
        address newOwner_,
        uint256 userWantCap_,
        uint256 totalWantCap_,
        bytes32 guestRoot_
    ) internal returns (ITestVipCappedGuestListBbtcUpgradeable clone) {
        // SafeGuard Parmas
        if (guestlistImpl_ == address(0)) revert AddressZero();
        if (wrapper_ == address(0)) revert AddressZero();
        if (newOwner_ == address(0)) revert AddressZero();
        if (userWantCap_ == 0) revert UintZero();
        if (totalWantCap_ == 0) revert UintZero();
        if (guestRoot_ == bytes32(0)) revert Bytes32Zero();

        // Deploy Clone
        clone = ITestVipCappedGuestListBbtcUpgradeable(
            ClonesUpgradeable.clone(guestlistImpl_)
        );

        // Init/Setup Clone
        clone.initialize(wrapper_);
        clone.setUserDepositCap(userWantCap_);
        clone.setTotalDepositCap(totalWantCap_);
        clone.setGuestRoot(guestRoot_);
        clone.transferOwnership(newOwner_);

        emit GuestListCreated(
            guestlistImpl_,
            clone,
            wrapper_,
            newOwner_,
            userWantCap_,
            totalWantCap_,
            guestRoot_
        );
    }
}
