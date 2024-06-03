// SPDX-License-Identifier: MIT
pragma solidity 0.8.25  ;


contract consumer {
    function getBalance()public view returns (uint) {
        return address(this).balance;
    }    

    function deposit() public payable  {
        
    }
}

contract SmartWallet {
    address payable public  owner ;
    address payable  nextOwner;
    
    uint guardiansResetCount;
    uint public constant confirmationFromGuradiansForReset = 3;

    mapping(address => uint) public  allowance;
    mapping(address => bool ) public isAllowedToSend;
    mapping(address => bool) public guardians;
    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedbool;



    constructor() {
        owner = payable(msg.sender);
    }

    function proposeNewOwner(address payable _newOwner) public  {
        require(guardians[msg.sender], "You are not a guardian of this wallet!, Go away  !!");
        require(nextOwnerGuardianVotedbool[_newOwner][msg.sender] == false, "You already voted, Aborting!!");

        if (_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount = 0;
            }

        guardiansResetCount++;

        if (guardiansResetCount >= confirmationFromGuradiansForReset) {
            owner = nextOwner;
            nextOwner= payable(address(0));
        }    

    }


    function setGuardian(address _guardian, bool _isGuardian) public  {
        require(msg.sender == owner, "You are not the owner!, Aborting!!");
        guardians[_guardian] = _isGuardian;
    }

    function setAllowance(address _for, uint _amount) public  {
         
          require(msg.sender == owner, "You are not the owner!, Aborting!!");

          allowance[_for] = _amount;

          if (_amount > 0 ) {
            isAllowedToSend[_for] = true;
          }else {
            isAllowedToSend[_for] = false;
          }

       
     }

    function transfer(address payable  _to, uint _amount, bytes memory _payload ) public returns(bytes memory)  {

        if (msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You atre not allowed to send anything to this smart contract, Aborting!!");
            require(allowance[msg.sender] >= _amount, "You are trying to send more than you are allowed to! , Aborting!!" );

            allowance[msg.sender] -= _amount;
        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success , "No success!, Aborting!!");
        return returnData;
    }

    receive() external payable { }
}