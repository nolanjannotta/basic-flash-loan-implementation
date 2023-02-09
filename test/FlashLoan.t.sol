// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/FlashLoanExecutor.sol";
import "../src/FlashLoanProvider.sol";
import "../src/FlashLoanTester.sol";

contract FlashLoanTest is Test {
    FlashLoanExecutor public exectutor;
    FlashLoanProvider public provider;
    FlashLoanTester public tester;

    function setUp() public {       
       provider = new FlashLoanProvider();
       tester = new FlashLoanTester();
       exectutor = new FlashLoanExecutor(address(provider), address(tester));
    }

    function fundProvider(uint amount) internal {
        vm.deal(address(this), amount);

        provider.fund{value:amount}();

        // or

        // address(provider).call{value: amount}("");

    }

    function testFundFlashLoanProvider() public {
        uint amount = 10_000 ether;
        fundProvider(amount);
        assertEq(address(provider).balance, amount);
    }

    function testFlashLoanApproach1() public {
        // fund provider
        testFundFlashLoanProvider();




        bool success = tester.success();
        assertEq(success, false);

        exectutor.execute(10_000 ether);

        success = tester.success();
        assertEq(success, true);

    }
}
