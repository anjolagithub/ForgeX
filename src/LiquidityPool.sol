// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/Interfaces/IERC20.sol";

contract LiquidityPool {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;

    mapping(address => uint256) public liquidity;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        reserveA += amountA;
        reserveB += amountB;
        liquidity[msg.sender] += amountA; // Simplified for demonstration
    }

    function removeLiquidity(uint256 amount) external {
        require(liquidity[msg.sender] >= amount, "Insufficient liquidity");

        uint256 amountA = (amount * reserveA) / reserveB;
        uint256 amountB = (amount * reserveB) / reserveA;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        reserveA -= amountA;
        reserveB -= amountB;
        liquidity[msg.sender] -= amount;
    }
}
