// SPDX-License-Identifier: MIT
pragma solidity 0.8.25  ;

contract MappingStructExample {

    struct Transaction {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numDeposits;
        mapping (uint => Transaction) deposits;
        uint numWithdrawals;
        mapping (uint=> Transaction) withdrawals;
    }


    mapping(address => Balance) public balances;

    function getDpositNum(address _from, uint _numDeposit) public view returns(Transaction memory) {
        return balances[_from].deposits[_numDeposit];
    }

    function getWithdrawalNum(address _from, uint _numwithdraw) public view returns(Transaction memory) {
        return balances[_from].withdrawals[_numwithdraw];
    }



    function depositMoney()public payable  {
        balances[msg.sender].totalBalance += msg.value;      

        Transaction memory deposit = Transaction(msg.value, block.timestamp); 
        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposit ;
        balances[msg.sender].numDeposits ++;
    }

    function withdrawMoney(address payable _to, uint _amount) public   {
        balances[msg.sender].totalBalance -=_amount;

        Transaction memory withdrawal = Transaction(_amount, block.timestamp);

        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawal;
        balances[msg.sender].numWithdrawals ++;


        _to.transfer(_amount);
    }

}

