// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/eip3156/FlashBorrower.sol";
import "../src/eip3156/FlashLoanLender.sol";
import "../src/eip3156/FlashTester.sol";
import "../src/eip3156/Token.sol";
import {IERC3156FlashBorrower} from "../src/eip3156/interfaces.sol";

contract EIP3156FlashLoanTest is Test {
    FlashBorrower public borrower;
    FlashLoanLender public lender;
    FlashTester public tester;
    Token public token;

    function setUp() public {       
       lender = new FlashLoanLender();
       
       
       token = new Token(address(lender));
       tester = new FlashTester(address(token));
       borrower = new FlashBorrower(address(tester), address(lender));
       token.mint(1_000_000 ether, address(borrower));
       assertEq(token.balanceOf(address(borrower)), 1_000_000 ether);
    }

    function testLenderTokenBalance() public {
        uint lenderBalance = token.balanceOf(address(lender));
        assertEq(lenderBalance, 1_000_000 ether);

    }
    // IERC3156FlashBorrower receiver,address token, uint256 amount,bytes calldata data

    function testFlashLoan() public {
        uint amount = 50_000 ether;
        bool success = tester.success();
        assertEq(success, false);
        lender.flashLoan(IERC3156FlashBorrower(borrower), address(token), amount, "");
        success = tester.success();
        assertEq(success, true);
        

    }


}
