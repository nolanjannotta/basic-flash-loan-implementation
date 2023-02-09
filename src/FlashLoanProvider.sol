// this contract provides the flash loan


contract FlashLoanProvider {


    constructor() {

    }

    function borrow(uint amount) public {
        require(amount <= address(this).balance, "low balance");
        

    }


    function payback() public {

    }
    
}