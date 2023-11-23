// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// payable 关键字可以接受以太坊主币的传入
contract Payable{
    address payable public owner;

    constructor(){
        // owner由合约部署者定义
        owner = payable(msg.sender);
    }

    function deposit() external payable{

    }   

    function getBalace() external view returns(uint){
        return address(this).balance;
    }

    
}