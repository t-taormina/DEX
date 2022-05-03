// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <= 0.9.0;
pragma experimental ABIEncoderV2;
import './wallet.sol';

contract Dex is Wallet {
    using SafeMath for uint;

    enum Side {
        BUY, 
        SELL
    }

    uint public IDtracker = 0;

    struct Order {
        uint id;
        address trader;
        Side side;
        bytes32 ticker; 
        uint amount;
        uint price;
    }

    mapping(bytes32 => mapping(uint => Order[])) public orderBook;

    function getOrderBook(bytes32 _ticker, Side _side) public view returns(Order[] memory) {
        return orderBook[_ticker][uint(_side)];
    }

    function createLimitOrder(Side _side, bytes32 _ticker, uint _amount, uint _price) public{
        if(_side == Side.BUY) {
            require(balances[msg.sender]["ETH"] >= _amount * _price,"Not enough tokens for sell order.");
        }
        else if(_side == Side.SELL) {
            require(balances[msg.sender][_ticker] >= _amount * _price, "Not enough tokens for sell order.");
        }
        Order[] storage orders = orderBook[_ticker][uint(_side)];
        orders.push(
            Order(IDtracker, msg.sender, _side, _ticker, _amount, _price));

        //Bubble sort
        uint i = orders.length > 0 ? orders.length - 1 : 0;

        if (_side == Side.BUY) {
            while(i > 0){ 
                if(orders[i - 1].price > orders[i].price){
                    break;
                }
                Order memory temp = orders[i];
                orders[i] = orders[i - 1];
                orders[i-1] = temp;
                i--;
            }
        }

        else if(_side == Side.SELL) {
            while(i > 0){ 
                if(orders[i - 1].price < orders[i].price){
                    break;
                }
                Order memory temp = orders[i];
                orders[i] = orders[i - 1];
                orders[i-1] = temp;
                i--;
            }
        }
        IDtracker = IDtracker.add(1);
    }
    
}
