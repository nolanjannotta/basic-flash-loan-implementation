// this contract has a function that is called by the executer contract that requires lots of ether, so if the flash loan works, 
// this function should be successful

pragma solidity 0.8.13;


contract FlashLoanTester {

    bool public success;


    function flashTest(uint amount) public payable {
        require(msg.value == amount, "Tester: incorrect price");
        (bool _success,) = msg.sender.call{value: msg.value}("");
        require(_success);
        success = true;

    }
}