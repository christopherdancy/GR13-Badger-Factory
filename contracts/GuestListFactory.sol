// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/proxy/ClonesUpgradeable.sol";
import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";
import "../interfaces/IGuestListFactory.sol";

contract GuestListFactory is IGuestListFactory{
    function createGuestList(
        address guestlistImpl_,
        address wrapper_,
        address newOwner_,
        uint256 userCap_,
        uint256 totalCap_,
        bytes32 guestRoot_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone) {
        // SafeGuard Parmas
        if(guestlistImpl_ == address(0)) revert AddressZero();
        if(wrapper_ == address(0)) revert AddressZero();
        if(newOwner_ == address(0)) revert AddressZero();
        if(userCap_ == 0) revert UintZero();
        if(totalCap_ == 0) revert UintZero();
        if(guestRoot_ == bytes32(0)) revert Bytes32Zero();

        // Deploy Clone
        clone = ITestVipCappedGuestListBbtcUpgradeable(
                ClonesUpgradeable.clone(guestlistImpl_)
            );

        // Init/Setup Clone
        clone.initialize(wrapper_);
        clone.setUserDepositCap(userCap_);
        clone.setTotalDepositCap(totalCap_);
        clone.setGuestRoot(guestRoot_);
        clone.transferOwnership(newOwner_);

        emit GuestListCreated(guestlistImpl_, wrapper_, newOwner_, userCap_, totalCap_, guestRoot_);
    }
}
