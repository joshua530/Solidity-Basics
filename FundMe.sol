// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Get funds from users(anyone)
// withdraw funds(owner of the contract)
// set minimum funding value in USD

import "./PriceConverter.sol";

error NotOwner(); // defined outside a contract

contract FundMe
{
    using PriceConverter for uint;

    uint public constant MINIMUM_USD = 50 * 1e18;
    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;
    /** owner of the contract
     * immutable is used for variables that are set once and not modified again
     * the difference between immutable and constant is that immutable variables
     * are not set on the same line as the one they are declared
     */
    address public immutable i_owner;

    constructor()
    {
        i_owner = msg.sender;
    }

    // payable allows the function to receive funds(aka native tokens like eth)
    // each time payable is used to cast an address[payable(0xasdfsdfsdf)] or as a modifier
    // like in this function, it makes the address or function able to receive funds
    // both contracts and wallets can hold native blockchain tokens
    function fund() public payable
    {
        // msg.value is used to get how many tokens are being sent(number of wei sent)
        // msg.sender contains address of sender
        // if amount < minimum, revert
        // revert - undo any action before & send remaining gas back
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    /**
     * withdraws funds and resets the funders array and mapping
     */
    function withdraw() public onlyOwner
    {
        for (uint256 funderIndex = 0; funderIndex < funders.length; ++funderIndex)
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset funders
        funders = new address[](0);
        // withdraw funds
        /*
         * ways of withdrawing
         * - transfer
         * - send
         * - call
         */

        // -- transfer => throws error on failure and reverts transaction
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);

        // -- send => returns boolean indicating whether transaction succeeded or not
        // it is up to the caller to determine whether to revert if the transaction failed
        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "Send failed");

        // -- call(low level command that can be used for several purposes)[recommended way of transfer]
        (
            bool callSuccess, /*bytes memory dataReturned*/
        ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send failed");
    }

    modifier onlyOwner()
    {
        // require(msg.sender == i_owner, "Sender is not owner");

        // custom error for gas efficiency
        if (msg.sender != i_owner)
            revert NotOwner();
        _; // run the code in the function. If put above the require statement, it will run all the code first
           // then check the condition. In this case, the condition is checked first before running the code
    }

    /**
     * trx sent without data. eg sent directly to the
     * contract instead of going through the fund function
     */
    receive() external payable
    {
        fund();
    }

    /** trx sent with data*/
    fallback() external payable
    {
        fund();
    }
}