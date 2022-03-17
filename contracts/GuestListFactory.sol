// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin-upgradeable/proxy/ClonesUpgradeable.sol";
import "../interfaces/ITestVipCappedGuestListBbtcUpgradeable.sol.sol";
import "../interfaces/IGuestListFactory.sol";
import "../interfaces/IOptimalSwap.sol";
import "../interfaces/ILPSwap.sol";
import "../interfaces/IUniswapV2Pair.sol";

contract GuestListFactory is IGuestListFactory{
    IOptimalSwap immutable public OptimalSwap;
    ILPSwap immutable public LPSwap;
    address immutable public Weth;

    constructor(IOptimalSwap optimalSwap, ILPSwap lpSwap, address weth) {
        OptimalSwap = optimalSwap;
        LPSwap = lpSwap;
        Weth = weth;
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
        // Check if token is a LP or an underlying asset
        uint256 userWantCap_;
        uint256 totalWantCap_;
        if (IUniswapV2Pair(wrapper_).token0() != address(0)) {
            uint256 lpPrice = LPSwap.findLPSwap(IUniswapV2Pair(wrapper_), OptimalSwap.UNI_ROUTER(), Weth, usdDenomToken_);
            userWantCap_ = lpPrice * userCapUSD_;
            totalWantCap_ = lpPrice * totalCapUSD_;
        } else {
            // Convert USD Cap to Want Cap
            (,userWantCap_) = OptimalSwap.findOptimalSwap(usdDenomToken_, wrapper_, userCapUSD_);
            (,totalWantCap_) = OptimalSwap.findOptimalSwap(usdDenomToken_, wrapper_, totalCapUSD_);
        }

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
