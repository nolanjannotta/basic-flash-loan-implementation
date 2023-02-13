// this contract will try to execute a flash loan and not pay back the full amount
pragma solidity 0.8.13;

// import "./IFlashLoanExecutor.sol";
import {IFlashLoanExecutor,IFlashLoanProvider,IFlashLoanTester} from "./Interfaces.sol";

contract MaliciousFlashLoanExecutor is IFlashLoanExecutor {


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
        flashLoanTester.flashTest{value:msg.value}(msg.value);

        
        // try to pay less than the loan amount back


        address(flashLoanProvider).call{value:msg.value - 1}("");
        // require(success);

    }

    ///////////////////////////////////////////////////////////////////////////////////



    

    ////////////////////////// approach #2 ////////////////////////////////////////////
    function execute2(uint amount) public {
        flashLoanProvider.borrow2(address(this), amount);

    }



    function onFlashLoan(address provider) public payable override {

        // do something
        flashLoanTester.flashTest{value:msg.value}(msg.value);
        
        
         // this function tries to pay less than the loan amount back
        provider.call{value: msg.value -1 }("");



    }


    

    ///////////////////////////////////////////////////////////////////////////////////
}