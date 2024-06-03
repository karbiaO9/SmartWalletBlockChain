// SPDX-License-Identifier: MIT
pragma solidity 0.8.25  ;

contract ContractOne {
    mapping(address => uint ) public addressBalances;
    function  deposit() public payable  {
        addressBalances[msg.sender] += msg.value;

    }
    
    receive() external payable {
        deposit();
     }

}

contract ContractTwo {
    receive() external payable { }

    function depositPnContractOne(address _contractOne) public {
        // bytes memory payload = abi.encodeWithSignature("deposit()");
        // ContractOne one = ContractOne(_contractOne);
        (bool success,) = _contractOne.call{value:10, gas: 100000}("");
        require(success);
    }


}