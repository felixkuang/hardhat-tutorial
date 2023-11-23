// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/access/Ownable.sol";

// 如果receive函数不存在，CALLDATA有值和没值都会调用fallback函数
contract Fallback is Ownable{
    event Log(string func,address sender,uint value,bytes data);

    // CALLDATA不为空时调用 fallback
    fallback() external payable {
        //require(msg.sender == owner(),"fallback not auth");
        assert(msg.sender == owner());
        emit Log("fallback",msg.sender,msg.value,msg.data);
    }

    // CALLDATA为空时调用 receive
    receive() external payable {
        //require(msg.sender == owner(),"receive not auth");
        assert(msg.sender == owner());
        emit Log("receive",msg.sender,msg.value,"");
    }
}