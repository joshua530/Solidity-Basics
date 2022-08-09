// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage
{
    // override is used when a function overrides one in the parent class
    function store(uint256 _favNum) public override
    {
        favoriteNumber = _favNum * _favNum;
    }
}