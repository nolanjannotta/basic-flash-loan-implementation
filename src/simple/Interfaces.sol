pragma solidity 0.8.13;

interface IFlashLoanProvider {

    function borrow(uint amount, bytes memory data) external;
    function borrow2(address executor, uint amount) external;
    function payback(uint amount) external payable;
}

interface IFlashLoanTester {
    function flashTest(uint amount) external payable;
}

interface IFlashLoanExecutor {

    function onFlashLoan(address provider) external payable;
    
}