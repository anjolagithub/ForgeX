// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/Interfaces/IERC20.sol";

contract Staking {
    IERC20 public lpToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewardDebt;

    uint256 public rewardRate = 100; // Example: 100 FGX per block
    uint256 public totalStaked;

    constructor(address _lpToken, address _rewardToken) {
        lpToken = IERC20(_lpToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 amount) external {
        lpToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender] += amount;
        totalStaked += amount;
    }

    function withdraw(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "Insufficient stake");
        lpToken.transfer(msg.sender, amount);
        stakes[msg.sender] -= amount;
        totalStaked -= amount;
    }

    function claimRewards() external {
        uint256 reward = (stakes[msg.sender] * rewardRate) / totalStaked;
        rewardToken.transfer(msg.sender, reward);
    }
}
