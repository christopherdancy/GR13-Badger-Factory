// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/proxy/ClonesUpgradeable.sol";
import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";

contract GuestListFactory {

    event GuestListCreated(address indexed guestList);
    function createGuestList(ITestVipCappedGuestListBbtcUpgradeable guestlistImpl) external returns(address){


    }
}
