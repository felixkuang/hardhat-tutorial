// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Data locations 
// storage 状态变量
// memory 局部变量，只在内存中使用，即使修改了值也不会改变状态变量
// calldata 只能用在参数中，如果用在参数中可以节约gas

contract DataLocations{
    struct Mystruct{
        uint foo;
        string text;
    }

    mapping(address => Mystruct) public myStructs;

    function example(uint[] calldata y, string calldata s) external returns(uint[] memory){
        myStructs[msg.sender] = Mystruct({foo: 123, text: "bar"});

        Mystruct storage myStruct = myStructs[msg.sender];
        myStruct.text = "foo";

        Mystruct memory readOnly = myStructs[msg.sender];
        readOnly.foo = 456;

        _internal(y);

        uint[] memory memArr = new uint[](3); 
        memArr[0] = 234;

        return memArr;
    }

    function _internal(uint[] calldata y) private{
        uint x = y[0];
    }
}