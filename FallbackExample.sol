// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract FallbackExample
{
    uint public result;

    /**
     * if a transaction is sent to this contract without any data
     * associated with the transaction, receive will get invoked
     */
    receive() external payable
    {
        result = 1;
    }

    /**
     * called when data is sent alongside a transaction 
     * to a contract 
     */
    fallback() external payable
    {
        result = 2;
    }
}

/*

                is msg.data empty?
                    /       \
                  yes       no
                  /           \
                receive()?    fallback()
                /   \
               yes  no
              /       \
            receive()  fallback()
*/