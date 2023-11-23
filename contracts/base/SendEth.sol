// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 3 ways to send ETH
// transfer - 2300 gas reverts
// send - 2300 gas, returns bool
// call - call gas , returns bool and data

contract SendEther{

    constructor() payable{}

    receive() external payable{}

    function sendViaTransfer(address payable _to) external payable{
        _to.transfer(123);
    }

    function sendViaTransfer() external payable{
        payable(msg.sender).transfer(123);
    }

    // 消耗剩余所有的gas
    function sendViaCall(address payable _to) external payable{
        //(bool success,bytes memory data) = _to.call{value:123}("");
        (bool success,) = _to.call{value:123}("");
        require(success,"send failed");
    }

    /**
     * 获取当前合约余额
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract EthReceiver {
    event Log(uint amount,uint gas);

    receive() external payable{
        emit Log(msg.value,gasleft());
    }
}  