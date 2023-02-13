// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(address lender) ERC20("Token", "T") {
        _mint(lender, 1_000_000 ether);

    }

    function mint(uint amount, address to) public {
        _mint(to, amount);
    }
}