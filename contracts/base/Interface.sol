// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ICounter{
    function count() external view returns(uint);
    function inc() external;
} 


contract Counter{
    uint public count;

    function inc() external{
        count += 1;
    }

    function dec() external{
        count -= 1;
    }
}

contract CallInterface{
    uint public count;

    function example(address counter) external{
        ICounter(counter).inc();
        count = ICounter(counter).count();
    }
}