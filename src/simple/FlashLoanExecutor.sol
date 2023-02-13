// this contract receives the loan and does something with the ether and then pays back the loan
pragma solidity 0.8.13;

// import "./IFlashLoanExecutor.sol";
import {IFlashLoanExecutor,IFlashLoanProvider,IFlashLoanTester} from "./Interfaces.sol";


contract FlashLoanExecutor is IFlashLoanExecutor {


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

    function payload() public virtual payable {

        // do some stuff
        // this function immediatly sends the ether back
        flashLoanTester.flashTest{value:msg.value}(msg.value);

        
        // payback

        // flashLoanProvider.payback{value:msg.value}();

        // or like this:
        (bool success,) = address(flashLoanProvider).call{value:msg.value}("");
        require(success);

    }

    ///////////////////////////////////////////////////////////////////////////////////



    

    ////////////////////////// approach #2 ////////////////////////////////////////////
    function execute2(uint amount) public {
        flashLoanProvider.borrow2(address(this), amount);

    }



    function onFlashLoan(address provider) public virtual payable override {
        // do some stuff
        // this function immediatly sends the ether back
        flashLoanTester.flashTest{value:msg.value}(msg.value);
        
        // payback the loan
        provider.call{value: msg.value}("");


    }


    

    ///////////////////////////////////////////////////////////////////////////////////
}