// SPDX-License-Identifier: MIN
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "hardhat/console.sol";

pragma solidity 0.8.19;

contract Vault {
    ERC20Permit public immutable token;

    constructor(address _token) {
        token = ERC20Permit(_token);
    }

    function deposit(uint amount) external {
        token.transferFrom(msg.sender, address(this), amount);
    }

    // function permit(
    //     address owner,
    //     address spender,
    //     uint256 value,
    //     uint256 deadline,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s
    // )

    function depositWithPermit(
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        console.log(
            "Transferring from %s to %s %s tokens",
            msg.sender,
            v,
            amount
        );
        uint256 balance = token.balanceOf(msg.sender);
        console.log("balance %s ", balance);
        token.permit(msg.sender, address(this), amount, deadline, v, r, s);
        uint256 allowance = token.allowance(msg.sender, address(this));
        console.log("allowance %s ", allowance);
        token.transferFrom(msg.sender, address(this), amount);
    }
}
