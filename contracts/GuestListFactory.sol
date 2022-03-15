// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/proxy/ClonesUpgradeable.sol";
import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";
import "../interfaces/IGuestListFactory.sol";
import "../interfaces/IOptimalSwap.sol";

contract GuestListFactory is IGuestListFactory{
    IOptimalSwap immutable OptimalSwap;

    constructor(IOptimalSwap optimalSwap) {
        OptimalSwap = optimalSwap;

    }

    function createGuestList(
        address guestlistImpl_,
        address usdDenomToken_,
        address wrapper_,
        address newOwner_,
        uint256 userCapUSD_,
        uint256 totalCapUSD_,
        bytes32 guestRoot_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone) {
        // Convert USD Cap to Want Cap
        (,uint256 userWantCap_) = OptimalSwap.findOptimalSwap(usdDenomToken_, wrapper_, userCapUSD_);
        (,uint256 totalWantCap_) = OptimalSwap.findOptimalSwap(usdDenomToken_, wrapper_, totalCapUSD_);

        // SafeGuard Parmas
        if(guestlistImpl_ == address(0)) revert AddressZero();
        if(usdDenomToken_ == address(0)) revert AddressZero();
        if(wrapper_ == address(0)) revert AddressZero();
        if(newOwner_ == address(0)) revert AddressZero();
        if(userWantCap_ == 0) revert UintZero();
        if(totalWantCap_ == 0) revert UintZero();
        if(guestRoot_ == bytes32(0)) revert Bytes32Zero();

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

        emit GuestListCreated(guestlistImpl_, clone, wrapper_, newOwner_, userWantCap_, totalWantCap_, guestRoot_);
    }
}
