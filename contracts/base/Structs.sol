// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Structs {
    struct Car {
        string model;
        uint256 year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    function example() external {
        Car memory toyota = Car("Toyota", 1990, msg.sender);
        Car memory lambo = Car({
            year: 1990,
            model: "lambojini",
            owner: msg.sender
        });
        Car memory tesla;
        tesla.model = "";
        tesla.year = 2000;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Honr", 2011, msg.sender));

        Car memory _car = cars[0];
        _car.model;
        _car.year = 1999;
        delete _car.owner;

        delete cars[1];
    }
}
