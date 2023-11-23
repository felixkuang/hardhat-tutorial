// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Array    dynamic or fixed size
// Initialization
// Insert (push), get, update, delete, pop, length
// Create array in memory
// Returning array from function

contract Array{
    uint[] public nums = [1, 2, 3];
    uint[3] public numsFixed = [4, 5, 6];

    function examples() external{
        nums.push(4);   // [1, 2, 3, 4]
       // uint x = nums[1];
        nums[2] = 100;  //  [1, 2, 100, 4]
        delete nums[1]; //  [1, 0, 100, 4]  
        nums.pop(); //  [1, 0, 100]  
        //uint len = nums.length; 

        // Create array in memory
        uint[] memory a = new uint[](5);
        a[1] = 200;
       
    }

    function returnArray() external view returns(uint[] memory){
        return nums;
    }
}