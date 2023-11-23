// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// visibility
// private  - only inside contract
// internal - only inside contract and child contract
// public - inside and outside contract
// external - only from outside contract

contract Visibility{
    uint private x =0;
    uint internal y = 1;
    uint public z = 2;
}
