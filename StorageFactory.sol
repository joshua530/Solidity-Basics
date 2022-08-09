// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory
{
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public
    {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    /**
     * to interact with a contract, one needs
     * - address of the contract
     * - ABI of the contract -> application binary interface(
     *   tells our code how it can interact with the contract)
     */
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public
    {
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256)
    {
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}