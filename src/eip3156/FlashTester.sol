pragma solidity 0.8.13;

import {IERC3156FlashBorrower,IERC3156FlashLender} from "./interfaces.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashTester {

    bool public success;
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);

    }


    function test(uint amount) public returns(bool) {
        require(token.transferFrom(msg.sender, address(this), amount));
        require(token.transfer(msg.sender, amount));
        success = true;
        return true;

    }
}