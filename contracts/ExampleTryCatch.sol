
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25  ;


contract Willthrow{
    error NotAllowedError(string);
    
    function aFunction() public pure  {
        // require(false,"Error message");
        // assert(false);
        revert NotAllowedError("Not Allowed Error");
    }
}


contract ErrorHandling {
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes (bytes LowLevelData);

    function catchError() public {
        Willthrow will = new Willthrow();
        try will.aFunction() {

        }  catch  Error(string memory reason) { 
            emit ErrorLogging(reason);
        }  catch Panic(uint errorCode) {
            emit ErrorLogCode(errorCode);
        }   catch(bytes memory LowLevelData) {
            emit ErrorLogBytes(LowLevelData);
        }
    }
}