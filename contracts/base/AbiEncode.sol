import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


contract AbiEncode {
    function test(address _contract, bytes calldata data) external {
        (bool ok, ) = _contract.call(data);
        require(ok, "call failed");
    }

    function multiCall(address[] calldata _contracts, bytes[] calldata data)
        external
    {
        require(_contracts.length == data.length, "target length != data length");

        for (uint256 i; i < _contracts.length; i++) {
            (bool success, )=_contracts[i].call(data[i]);
            require(success,"call failed");
        }
    }

    function encodeWithSignature(
        address to,
        uint amount
    ) external pure returns (bytes memory) {
        // Typo is not checked - "transfer(address, uint)"
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    function encodeWithTransferSelector(
        address to,
        uint amount
    ) external pure returns (bytes memory) {
        // Type is not checked - (IERC20.transfer.selector, true, amount)
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }
    function encodeWithApproveSelector(
        address spender,
        uint amount
    ) external pure returns (bytes memory) {
        // Type is not checked - (IERC20.transfer.selector, true, amount)
        return abi.encodeWithSelector(IERC20.approve.selector, spender, amount);
    }

    function encodeCall(address to, uint amount) external pure returns (bytes memory) {
        // Typo and type errors will not compile
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}