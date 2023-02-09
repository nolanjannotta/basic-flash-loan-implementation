// this contract provides the flash loan
pragma solidity 0.8.13;

contract FlashLoanProvider {

    constructor() {

    }

    receive() external payable {}

    function fund() public payable {}


    ////////////////////////// approach #1 ////////////////////////////////////////////

    function borrow(uint amount, bytes memory data) public {
        uint balance = address(this).balance;
        require(amount <= balance, "low balance"); // not technically neccessary, right? 


        // send the loan and execute provided payload
        (bool success,) = msg.sender.call{value: amount}(data);
        require(success); // is this require statement neccessary? is success is false, loan wont be paid back and will be caught by next require



        // make sure the exact amount is paid back
        require(balance == address(this).balance, "loan not paid back"); 


    }


    // function payback() public payable {
    // }

    ///////////////////////////////////////////////////////////////////////////////////


    ////////////////////////// approach #2 ////////////////////////////////////////////




    ///////////////////////////////////////////////////////////////////////////////////
    
}