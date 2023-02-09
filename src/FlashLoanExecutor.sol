// this contract receives the loan and does something with the ether and then pays back the loan
pragma solidity 0.8.13;

interface IFlashLoanProvider {

    function borrow(uint amount, bytes memory data) external;
    function payback() external payable;
}

interface IFlashLoanTester {
    function test() external payable;
}


contract FlashLoanExecutor {


    IFlashLoanProvider public flashLoanProvider;
    IFlashLoanTester public flashLoanTester;

    constructor(address _flashLoanProvider, address _flashLoanTester) {
        flashLoanProvider = IFlashLoanProvider(_flashLoanProvider);
        flashLoanTester =  IFlashLoanTester(_flashLoanTester);

    }
    receive() external payable {}


    ////////////////////////// approach #1 ////////////////////////////////////////////

    function execute(uint amount) public {
        flashLoanProvider.borrow(amount, abi.encodeWithSelector(this.payload.selector));

    }

    function payload() public payable {

        // do some stuff
        // this function immediatly sends the ether back
        flashLoanTester.test{value:msg.value}();

        
        // payback

        // flashLoanProvider.payback{value:msg.value}();

        // or like this:
        (bool success,) = address(flashLoanProvider).call{value:msg.value}("");
        require(success);

    }

    ///////////////////////////////////////////////////////////////////////////////////



    

    ////////////////////////// approach #2 ////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////
}