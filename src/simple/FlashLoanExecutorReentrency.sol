pragma solidity 0.8.13;

import "./FlashLoanExecutor.sol";



contract FlashLoanExecutorReentrency is FlashLoanExecutor {

    constructor(address _flashLoanProvider, address _flashLoanTester) FlashLoanExecutor(_flashLoanProvider, _flashLoanTester) {

    }

    function payload() public payable override {

        // do some stuff
        // this function immediatly sends the ether back
        flashLoanProvider.borrow(10 ether,abi.encodeWithSelector(this.payload.selector));

        
        // payback

        // flashLoanProvider.payback{value:msg.value}();

        // or like this:
        (bool success,) = address(flashLoanProvider).call{value:msg.value}("");
        require(success, "payback fail");

    }

    function onFlashLoan(address provider) public payable override(FlashLoanExecutor) {
        // here we are trying to call borrow2 in the middle of our loan, causing a reentrency
        flashLoanProvider.borrow2(address(this), 1 ether);
        
        // payback the loan
        provider.call{value: msg.value}("");


    }



}