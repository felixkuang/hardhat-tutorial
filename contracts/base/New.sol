// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;

    function createAccount(address _owner) external payable{
        // {value:msg.value} 给新创建的合约带上主币
        Account account = new Account{value: msg.value}(_owner);
        accounts.push(account);
    }
}
