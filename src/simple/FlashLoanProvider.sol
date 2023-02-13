// this contract provides the flash loan of eth
pragma solidity 0.8.13;


// import "./IFlashLoanExecutor.sol";
import {IFlashLoanExecutor} from "./Interfaces.sol";

contract FlashLoanProvider {
    bool isLending; 
    // to prevent reentrency
    modifier CanLend {
        require(!isLending, "no reentrency");
        isLending = true;
        _;
        isLending = false;
    }

    constructor() {

    }

    receive() external payable {}

    function fund() public payable {}


    ////////////////////////// approach #1 ////////////////////////////////////////////

    function borrow(uint amount, bytes calldata payloadData) public CanLend {
        uint balance = address(this).balance;
        require(amount <= balance, "low balance"); // not technically neccessary, right? 


        // send the loan and execute provided payload
        (bool success,) = msg.sender.call{value: amount}(payloadData);
        require(success, "payload failed"); // is this require statement neccessary? is success is false, loan wont be paid back and will be caught by next require



        // make sure the exact amount is paid back 
        require(balance == address(this).balance, "loan not paid back"); 


    }

    ///////////////////////////////////////////////////////////////////////////////////





    ////////////////////////// approach #2 ////////////////////////////////////////////


    function borrow2(address executor, uint amount) public CanLend {
        uint balance = address(this).balance;
        require(amount <= balance, "low balance");

        // bytes memory payback = abi.encodeWithSelector(this.payback.selector, amount);
        IFlashLoanExecutor(executor).onFlashLoan{value: amount}(address(this));

        require(balance == address(this).balance, "loan not paid back"); 
    }

    function payback(uint amount) public payable{
        require(msg.value == amount, "loan not paid back :(");

    }




    ///////////////////////////////////////////////////////////////////////////////////



    ////////////////////////// erc20 flashloan ////////////////////////////////////////

    function borrowERC20(address token, uint amount) public {

    }

    function paybackERC20() public {

    }






    ///////////////////////////////////////////////////////////////////////////////////





    
    
}