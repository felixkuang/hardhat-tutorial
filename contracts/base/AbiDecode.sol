// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AbiDecode{

    struct MyStruct{
        string name;
        uint[2] nums;
    }

    /*
        x:1
        address:0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
        arr:[1,2,3]
        myStruct:["Solidity",[4,5]]
    */
    function encode(
        uint x,
        address addr,
        uint[] calldata arr,
        MyStruct calldata myStruct
    ) external pure returns(bytes memory){
        return abi.encode(x, addr, arr, myStruct);
    }

    function decode(bytes calldata data) external pure returns(
         uint x,
        address addr,
        uint[] memory arr,
        MyStruct memory myStruct
    ){
        (x, addr, arr, myStruct) = abi.decode(data,(uint, address, uint[], MyStruct));
    }
}