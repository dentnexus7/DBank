// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  Token private token;

  //add mappings
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;

  //add events
  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);

  constructor(Token _token) public {
    token = _token;
  }

  function deposit() payable public {
    require(isDeposited[msg.sender] == false, 'Error, deposit already active');
    require(msg.value >= 1e16, 'Error, deposit must be >= .01ETH');

    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

    isDeposited[msg.sender] = true; // activate deposit status
    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    require(isDeposited[msg.sender], 'Error, no previous deposit');

    // Get deposit amount and deposit time
    uint userBalance = etherBalanceOf[msg.sender]; // for event
    uint depositTime = block.timestamp - depositStart[msg.sender];

    // Calculate interest
    // 31668017 - interest(10% APY) per second for min. deposit amount (0.01 ETH), cuz:
    // 1e15(10% of 0.01 ETH) / 31577600 (seconds in 365.25 days)
    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
    uint interest = interestPerSecond * depositTime;

    // Send Ether and Interest accrued
    msg.sender.transfer(userBalance);
    token.mint(msg.sender, interest); // interest to user

    // Reset depositer data
    depositStart[msg.sender] = 0;
    etherBalanceOf[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    //emit event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}