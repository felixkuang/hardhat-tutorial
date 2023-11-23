// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TestCall {
    string public message;
    uint256 public x;

    event Log(string message);

    // fallback() external {
    //     emit Log("fallback was called");
    // }
    fallback() external {
        emit Log("fallback was called");
    }

    function foo(string memory _message, uint256 _x)
        external
        payable
        returns (bool, uint256)
    {
        message = _message;
        x = _x;
        return (true, 999);
    }
}

contract Call {
    bytes public data;

    function callFoo(address _test) external payable {
        // (bool success, bytes memory _data) = _test.call{value: 111, gas: 5000}(
        //     abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        // );
        (bool success, bytes memory _data) = _test.call{value: 111}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        );
        require(success, "call failed");
        data = _data;
    }
    // 如果不存在 fallback 函数，会报错
    function callDoseNotExit(address _test) external {
        (bool success, ) = _test.call(
            abi.encodeWithSignature("doseNotExist()")
        );
        require(success, "call failed");
    }

    function decode(bytes calldata _data) external pure returns(bool a,uint256 b){

        (a,b) = abi.decode(_data, (bool,uint256));
    }
}
