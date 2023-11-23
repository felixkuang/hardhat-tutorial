// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TestMultiCall {
    function func1() external view returns (uint, uint) {
        return (1, block.timestamp);
    }

    function func2() external view returns (uint, uint) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns(bytes memory) {
        //abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns(bytes memory) {
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);

        for (uint256 i; i < targets.length; i++) {
            (bool success,bytes memory result)=targets[i].staticcall(data[i]);
            require(success,"call failed");
            results[i] = result;
        }

        return results;
    }
}
