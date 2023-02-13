pragma solidity 0.8.13;

import {IERC3156FlashBorrower,IERC3156FlashLender} from "./interfaces.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract FlashLoanLender is IERC3156FlashLender {
    
    uint fee = 1_00; // 1%
    


    constructor() {
        

    }
    // users can borrow up to the entire token balance of this contract 
    function maxFlashLoan(address token) public override view returns(uint) {
        return IERC20(token).balanceOf(address(this));

    }

    // the eip says this:
    // flashFee reverts on unsupported tokens, because returning a numerical value would be incorrect.
    // what makes a token unsupported tokens? if the balance of zero?

    function flashFee(address token,uint256 amount) public override view returns (uint256) {
        return (amount * fee) / 10_000;




    }
    function flashLoan(IERC3156FlashBorrower receiver,address token, uint256 amount,bytes calldata data) public override returns (bool){
        uint max = maxFlashLoan(token);
        require(max > 0 && amount <= max, "token not supported or amount too high");

        require(IERC20(token).transfer(address(receiver), amount), "loan transfer fail");
        
        uint fee = flashFee(token, amount);

        require(receiver.onFlashLoan(msg.sender, token, amount, fee, data) == keccak256("ERC3156FlashBorrower.onFlashLoan"),"IERC3156: Callback failed");

        bool paid = IERC20(token).transferFrom(address(receiver), address(this), amount + fee);
        require(paid, "loan not paid back");
        return true;

    }









}