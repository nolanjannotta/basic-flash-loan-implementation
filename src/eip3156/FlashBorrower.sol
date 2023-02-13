pragma solidity 0.8.13;

import {IERC3156FlashBorrower,IERC3156FlashLender,IFlashTester} from "./interfaces.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./FlashTester.sol";


contract FlashBorrower is IERC3156FlashBorrower {

    IFlashTester public tester;
    address public lender;

    constructor(address _tester, address _lender) {
        tester = IFlashTester(_tester);
        lender = _lender;

    }

    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data) public override returns (bytes32) {
        // do stuff
        IERC20(token).approve(address(tester), amount);
        require(tester.test(amount));


        require(IERC20(token).approve(lender, amount + fee ), "approval fail");

        return keccak256("ERC3156FlashBorrower.onFlashLoan");


    }




}