// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";

interface IGuestListFactory {
    event GuestListCreated(address guestlistImpl_,
        address wrapper_,
        uint256 userCap_,
        uint256 totalCap_,
        bytes32 guestRoot_,
        address newOwner_
    );

    function createGuestList(
        address guestlistImpl_,
        address wrapper_,
        uint256 userCap_,
        uint256 totalCap_,
        bytes32 guestRoot_,
        address newOwner_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone);
}
