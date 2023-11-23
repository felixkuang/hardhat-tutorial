// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TestDelegateCall {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) external payable {
        num = 2 * _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVar(address _test, uint256 _num) external payable {
        // _test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
        );
        require(success, "delegateCall failed");
    }

    function methodId() external pure returns (bytes4 mSelector){
        mSelector = TestDelegateCall.setVars.selector;
    }
}
