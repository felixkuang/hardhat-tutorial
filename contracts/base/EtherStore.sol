// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EtherStore{
    mapping(address => uint) public balances;

    function deposit() public payable{
        balances[msg.sender] += msg.value; 
    }

    function withdraw(uint _amount) external{
        require(balances[msg.sender] >= _amount);

        (bool sent,) = msg.sender.call{value:_amount}("");
        require(sent, "failed to sent ether");

        balances[msg.sender] -= _amount;
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}