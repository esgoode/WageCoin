pragma solidity ^0.4.24;

/// @title Betting with minting

contract WageCoin {
    struct BetEvent{
        string name;
        uint payout;
        uint amount;
        bool occured;
    }
    
    struct gamblers{
        uint balance;
        BetEvent bet;
    }
    
    address public minter;
    mapping (address => gamblers) public users;
    uint escrow;
    
    event Sent(address from, address to, uint amount);
    
    //constructor
    constructor() public {
        minter = msg.sender;
    }
    
    //create coin
    function mint(address receiver, uint amount) public {
        users[receiver].balance += amount;
    }
    
    
    function transfer(address receiver, uint amount) public {
        if (users[msg.sender].balance < amount) return;
        users[msg.sender].balance -= amount;
        users[receiver].balance += amount;
        
        //call event
        emit Sent(msg.sender, receiver, amount);
    }
    
    function gamble(uint amount, string name, uint payout) public {
        users[msg.sender].balance -= amount;
        users[msg.sender].bet.name = name;
        users[msg.sender].bet.payout = payout;
        users[msg.sender].bet.amount = amount;
        users[msg.sender].bet.occured = false;
        
    }
    
    function resolveBet() public {
        if(users[msg.sender].bet.occured){
            users[msg.sender].balance += users[msg.sender].bet.payout;
        }
    }
    
    function updateBet() public {
        users[msg.sender].bet.occured = true;
    }
    
    function getBalance() view public returns (uint){
        return users[msg.sender].balance;
    }
}