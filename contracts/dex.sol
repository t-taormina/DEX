// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <= 0.9.0;

contract Dex is Wallet {

    struct Order {
        uint id;
        address trader;
        bool buyOrder;
        bytes32 ticker; 
        uint amount;
    }



}