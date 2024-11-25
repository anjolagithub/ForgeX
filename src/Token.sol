// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ForgeXToken is ERC20 {
    constructor() ERC20("ForgeX Token", "FGX") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}

