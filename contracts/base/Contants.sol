// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Constants {
    // 373 gas 
    address public constant MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint256 public constant MY_UINT = 123;
    uint256[] public Array;

}

contract Vars {
    // 2483 gas
    address public MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; 
}

contract Immutable {
    // 351 gas
    address public immutable MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; 
}
