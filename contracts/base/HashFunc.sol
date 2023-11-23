// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HashFun{
    function hash(string memory text, uint num, address addr) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
    }

    function encode(string memory text0, string memory text1) external pure returns(bytes memory) {
        return abi.encode(text0, text1);
    }

    // 会有哈希碰撞问题
    function encodePacked(string memory text0,uint x, string memory text1) external pure returns(bytes memory) {
        return abi.encodePacked(text0,x, text1);
    }

    // 哈希碰撞
    // "AAA","ABBB" 和 "AAAA","BBB"  等到的hash值一样
    // 中间加一个uint数字可以解决
    function collision(string memory text0, uint x, string memory text1) external pure returns(bytes32){
        return keccak256(abi.encodePacked(text0, x, text1));
    }
}

