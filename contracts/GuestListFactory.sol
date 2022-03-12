// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/proxy/ClonesUpgradeable.sol";
import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";
import "../interfaces/IGuestListFactory.sol";

contract GuestListFactory is IGuestListFactory{
    function createGuestList(
        address guestlistImpl_,
        address wrapper_,
        uint256 userCap_,
        uint256 totalCap_,
        bytes32 guestRoot_,
        address newOwner_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone) {
        clone = ITestVipCappedGuestListBbtcUpgradeable(
                ClonesUpgradeable.clone(guestlistImpl_)
            );

        // Init/Setup Clone
        clone.initialize(wrapper_);
        clone.setUserDepositCap(userCap_);
        clone.setTotalDepositCap(totalCap_);
        clone.setGuestRoot(guestRoot_);
        clone.transferOwnership(newOwner_);

        emit GuestListCreated(guestlistImpl_, wrapper_, userCap_, totalCap_, guestRoot_, newOwner_);
    }
}
