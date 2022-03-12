// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";

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

    function createGuestList(
        address guestlistImpl_,
        address wrapper_,
        address newOwner_,
        uint256 userCap_,
        uint256 totalCap_,
        bytes32 guestRoot_
    ) external returns (ITestVipCappedGuestListBbtcUpgradeable clone);
}
