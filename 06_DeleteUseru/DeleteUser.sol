// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "hardhat/console.sol";

/**
 * This contract starts with 1 ether.
 * Your goal is to steal all the ether in the contract.
 */
contract DeleteUser {
    struct User {
        address addr;
        uint256 amount;
    }

    User[] private users;

    function deposit() external payable {
        users.push(User({addr: msg.sender, amount: msg.value}));
    }

    function withdraw(uint256 index) external {

        User storage user = users[index];

        require(user.addr == msg.sender, 'incorrect user for that index');
        console.log('withdraw', index);
        uint256 amount = user.amount;

        user = users[users.length - 1];
        users.pop();

        msg.sender.call{value: amount}("");
    }
}

// users [{addr: victimAddy; amount: 1 ether}, {addr: attackerAddy; amount: 0}]

// withdraw
//   get user object from storage
//   check address and get amount
//   set users[<index>] to last user in array
//   pop() array


// idea: reenter on eth xfer and deposit again --> maybe this way addr will be this contract instead of attackers
// then use this to withdraw(0)
// maybe send that $$ to attackwallet