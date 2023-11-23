// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract S{
    string public name;

    constructor(string memory _name){
        name = _name;
    }
}

contract T{
    string public text;

    constructor(string memory _text){
        text = _text;
    }
}
// 已知父构造函数参数内容
contract U is S("s"),T("t"){

}

contract V is S,T{
    constructor(string memory _name, string memory _text) S(_name) T(_text){

    }
}

// 混合使用
contract VV is S("s"),T{
    constructor(string memory _text) T(_text){

    }
}



contract E {
    event Log(string message);

    function foo() public virtual{
        emit Log("E.foo");
    }
    function bar() virtual public{
        emit Log("E.bar");
    }
}


contract F is E {

    function foo() public virtual override{
        emit Log("F.foo");
        E.foo();
    }
    function bar() public virtual override{
        emit Log("F.bar");
        super.bar();
    }
}

contract G is E {

    function foo() public virtual override{
        emit Log("G.foo");
        E.foo();
    }
    function bar() public virtual override{
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F,G {

    function foo() public override(F,G){
        F.foo();
    }
    function bar() public override(F,G){
        super.bar();
    }
}
