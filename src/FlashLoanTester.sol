// this contract has a function that is called by the executer contract that requires lots of ether, so if the flash load works, 
// this function should be successful

pragma solidity 0.8.13;


contract FlashLoanTester {


    function test() public payable {
        require(msg.value == 10_000 ether, "nope");
        (bool success,) = msg.sender.call{value: msg.value}("");
    }
}