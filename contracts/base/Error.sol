// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// require revert assert
// gas refund, state updates are reverted
// custom error - save gas  自定义错误，节约gas

contract ErrorTest{
    function testRequire(uint i) public pure {
        require(i <= 10,"i > 10");
        //code
    }

    function testRevert(uint i) public pure {
         if(i >1){
            if(i >2){
                 if(i >10){
                    revert("i > 10");
                }
                //code
            }
            
        }
    }

    uint public num = 123;
    function testAssert() public view{
        assert(num == 123);
    } 

    // function foo() public{
    //     num += 1;
    // } 

    function foo(uint _i) public{
        num += 1;
        require(_i < 10,"i < 10");
    }   

    error MyError(address caller, uint i);
    error Paused(address);

    function testCustomError(uint _i) public view{
         //require(_i <= 10,"very long error message error error error error error error error error");
         if(_i > 10){
             //gasleft();
             revert MyError(msg.sender,_i);
         }
    }
    function PausedError() external view{
        revert Paused(msg.sender);
    }
}
