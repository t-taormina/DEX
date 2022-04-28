// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <= 0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Wallet is Ownable {
    using SafeMath for uint256;

    struct Token {
        bytes32 ticker;
        address tokenAddress;
    }

    modifier tokenExists(bytes32 ticker) {
        require(tokenMapping[ticker].tokenAddress != address(0), "Token doesn't exist");
        _;
    }

// Storage for our Token objects
    bytes32[] public tokenList;
    mapping(bytes32 => Token) public tokenMapping;

// Mapping to use a users address -> token name in bytes -> to the
// balance of that token for the specified user.
    mapping(address => mapping(bytes32 => uint256)) public balances;

// Different functions we will need for the tokens
// Add token
// Transfer Token
// Delete Token

    function addToken(bytes32 _ticker, address _tokenAddress) onlyOwner external {
        tokenMapping[_ticker] = Token(_ticker, _tokenAddress);
        tokenList.push(_ticker);
    }

    function deposit(uint amount, bytes32 _ticker) tokenExists(_ticker) external {
        IERC20(tokenMapping[_ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][_ticker] = balances[msg.sender][_ticker].add(amount); 
    }

    function withdraw(uint amount, bytes32 _ticker) tokenExists(_ticker) external {
        require(balances[msg.sender][_ticker] >= amount, "Insufficient balance");
        balances[msg.sender][_ticker] = balances[msg.sender][_ticker].sub(amount);
        IERC20(tokenMapping[_ticker].tokenAddress).transfer(msg.sender, amount);
    }

}