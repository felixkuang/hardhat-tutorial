// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CrowdFund is ERC20{
    ERC20 public immutable token;

    constructor(address _token) ERC20("a","b"){
        token = ERC20(_token);
    }
}