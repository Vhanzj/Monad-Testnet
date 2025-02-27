// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartWallet {
    address public owner;

    // Events
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    event Execution(address indexed target, uint256 value, bytes data);

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Constructor to set the owner
    constructor() {
        owner = msg.sender;
    }

    // Fallback function to accept Ether
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Deposit Ether into the wallet
    function deposit() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw Ether from the wallet
    function withdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner).transfer(amount);
        emit Withdrawal(owner, amount);
    }

    // Execute a transaction (e.g., call another contract)
    function execute(address target, uint256 value, bytes calldata data) external onlyOwner {
        (bool success, ) = target.call{value: value}(data);
        require(success, "Execution failed");
        emit Execution(target, value, data);
    }

    // Get the wallet's balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
