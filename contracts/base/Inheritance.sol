// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// virtual 定义为可以被重写
// override 覆盖父合约的函数
contract A{
    function foo() public pure virtual returns(string memory){
        return "A";
    }

    function bar() public pure virtual returns(string memory){
        return "A";
    }

    function baz() public pure returns (string memory){
        return "A";
    }
}

contract B is A{
    function foo() public pure override returns(string memory){
        return "B";
    }

    function bar() public pure virtual override returns(string memory){
        return "B";
    }
}

contract C is B{
    function bar() public pure override returns(string memory){
        return "C";
    }
}