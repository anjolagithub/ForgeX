// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/Interfaces/IERC20.sol";

contract Swap {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function swap(address fromToken, address toToken, uint256 amountIn) external {
        require(fromToken == address(tokenA) || fromToken == address(tokenB), "Invalid token");
        require(toToken == address(tokenA) || toToken == address(tokenB), "Invalid token");

        uint256 amountOut = getAmountOut(amountIn, fromToken == address(tokenA) ? reserveA : reserveB, fromToken == address(tokenA) ? reserveB : reserveA);

        IERC20(fromToken).transferFrom(msg.sender, address(this), amountIn);
        IERC20(toToken).transfer(msg.sender, amountOut);

        if (fromToken == address(tokenA)) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        uint256 amountInWithFee = amountIn * 997; // 0.3% fee
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 1000) + amountInWithFee;
        return numerator / denominator;
    }
}
