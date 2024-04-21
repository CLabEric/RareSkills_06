// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "hardhat/console.sol";

contract Wallet {
    address public immutable forwarder;

    constructor(address _forwarder) payable {
        require(msg.value == 1 ether);
        forwarder = _forwarder;
    }

    function sendEther(address destination, uint256 amount) public {
        require(msg.sender == forwarder, "sender must be forwarder contract");
        (bool success,) = destination.call{value: amount}("");
        require(success, "failed");
    }
}

contract Forwarder {
    receive() external payable {}

    function functionCall(address a, bytes calldata data) public {
        bytes memory d = abi.encodeWithSignature("sendEther(address,uint256)", address(this), 1 ether);
        (bool success,) = a.call(d);
        require(success, "forward failed");
    }
}
