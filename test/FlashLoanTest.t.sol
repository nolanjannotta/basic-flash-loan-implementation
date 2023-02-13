// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/simple/FlashLoanExecutor.sol";
import "../src/simple/MaliciousFlashLoanExecutor.sol";
import "../src/simple/FlashLoanExecutorReentrency.sol";
import "../src/simple/FlashLoanProvider.sol";
import "../src/simple/FlashLoanTester.sol";

contract FlashLoanTest is Test {
    FlashLoanExecutor public exectutor;
    FlashLoanProvider public provider;
    FlashLoanTester public tester;
    MaliciousFlashLoanExecutor public maliciousExecutor;
    FlashLoanExecutorReentrency public reentrencyExecutor;

    function setUp() public {       
       provider = new FlashLoanProvider();
       tester = new FlashLoanTester();
       exectutor = new FlashLoanExecutor(address(provider), address(tester));
       maliciousExecutor = new MaliciousFlashLoanExecutor(address(provider), address(tester));
       reentrencyExecutor = new FlashLoanExecutorReentrency(address(provider), address(tester));
    }
    receive() external payable {}

    function fundProvider(uint amount) internal {
        vm.deal(address(this), amount);

        provider.fund{value:amount}();

        // or

        // address(provider).call{value: amount}("");

    }

    function testTestContract() public {
        vm.deal(address(this), 5 ether);
        console.log(address(this).balance);
        tester.flashTest{value: 3 ether}(3 ether);
    }

    function testFundFlashLoanProvider() public {
        uint amount = 10_000 ether;
        fundProvider(amount);
        assertEq(address(provider).balance, amount);
    }

    function testFlashLoanApproach1() public {
        // fund provider
        testFundFlashLoanProvider();
        uint providerBalanceBefore = address(provider).balance;



        bool success = tester.success();
        assertEq(success, false);

        exectutor.execute(10_000 ether);

        success = tester.success();
        assertEq(success, true);

        // make sure provider balance does not change
        assertEq(providerBalanceBefore, address(provider).balance);

    }

    // function testWrongTestPrice() public {
    //     testFundFlashLoanProvider();
    //     vm.expectRevert("payload failed");
    //     exectutor.execute(9_000 ether);
    // }


    function testFlashLoanApproach2() public {
         // fund provider
        testFundFlashLoanProvider();
        uint providerBalanceBefore = address(provider).balance;
        bool success = tester.success();
        assertEq(success, false);

        exectutor.execute2(10_000 ether);

        success = tester.success();
        assertEq(success, true);

        // make sure provider balance does not change
        assertEq(providerBalanceBefore, address(provider).balance);

    }


    function testMaliciousFlashLoanApproach1() public {
        // fund provider
        testFundFlashLoanProvider();
        uint providerBalanceBefore = address(provider).balance;
        vm.expectRevert("loan not paid back");
        maliciousExecutor.execute(10_000 ether);

        // make sure provider balance does not change
        assertEq(providerBalanceBefore, address(provider).balance);


    }

    function testMaliciousFlashLoanApproach2() public {
         // fund provider
        testFundFlashLoanProvider();
        uint providerBalanceBefore = address(provider).balance;

        vm.expectRevert("loan not paid back");
        maliciousExecutor.execute2(10_000 ether);

        // make sure provider balance does not change
        assertEq(providerBalanceBefore, address(provider).balance);

    }

    function testReentrencyFlashLoanApproach1() public {
        // fund provider
        testFundFlashLoanProvider();
        uint providerBalanceBefore = address(provider).balance;
        vm.expectRevert("payload failed");
        reentrencyExecutor.execute(10_000 ether);
        // make sure provider balance does not change
        assertEq(providerBalanceBefore, address(provider).balance);


    }

    function testReentrencyFlashLoanApproach2() public {
         // fund provider
        testFundFlashLoanProvider();
        uint providerBalanceBefore = address(provider).balance;


        vm.expectRevert("no reentrency");
        reentrencyExecutor.execute2(10_000 ether);

        // make sure provider balance does not change
        assertEq(providerBalanceBefore, address(provider).balance);

    }
}
