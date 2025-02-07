// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./macho-token.sol"; // Import the MachoToken contract

contract MachoTokenSavings {
    MachoToken public machoToken; // Reference to the MachoToken contract

    mapping(address => uint256) private _deposits;

    // Events for logging deposits and withdrawals
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    // Constructor to initialize the reference to the MachoToken contract
    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Invalid token address");
        machoToken = MachoToken(tokenAddress); // Set the MachoToken contract address
    }

    // Function for users to deposit MachoTokens into the savings contract
    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(machoToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        _deposits[msg.sender] += amount;

        emit Deposited(msg.sender, amount);
    }

    function balanceOf(address user) external view returns (uint256) {
        return _deposits[user];
    }

    // Function for users to withdraw their deposited MachoTokens
    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(_deposits[msg.sender] >= amount, "Insufficient deposited balance");

        // Decrease the user's deposit balance
        _deposits[msg.sender] -= amount;

        // Transfer tokens back to the user's wallet
        require(machoToken.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }
}