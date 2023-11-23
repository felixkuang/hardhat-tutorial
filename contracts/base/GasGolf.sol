// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GasGolf{
    // start - 56694 gas
    // use calldata  -  47716  gas
    // load state variables to memory   -  46848  gas
    // short circuit  --  
    // loop increments  -   46823  gas
    // cache array lenth  -  46796   gas 
    //    gas

    uint public total;

    //[1,2,3,4,5] 
    function sum(uint[] calldata _nums) external{
        uint _total = total;
        uint len = _nums.length;

        for (uint256 i=0; i < len; ++i) { 
            uint num = _nums[i];
            _total += num;
        }
        total = _total;
    }   

}