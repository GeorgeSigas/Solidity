// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BBSEToken.sol";

contract BBSEBank {
  // BBSE Token Contract instance
  BBSEToken private bbseTokenContract;
  
  // Yearly return rate of the bank
  uint32 public yearlyReturnRate;
  
  // Seconds in a year
  uint32 public constant YEAR_SECONDS = 31536000; 

  // Average block time in Ethereum
  uint8 public constant AVG_BLOCK_TIME = 14;
  
  // Minimum deposit amount
  // TODO: Create a MIN_DEPOSIT_AMOUNT constant variable
  uint public constant MIN_DEPOSIT_AMOUNT=10**18;
  /* Interest earned per second for a minumum deposit amount.
   * Equals to the yearly return of the minimum deposit amount
   * divided by the number of seconds in a year.
  */
  uint public interestPerSecondForMinDeposit;

  // Represents an investor record
  struct Investor {   // TODO: Complete the missing types
    // hasActiveDeposit;
    // amount;
    bool hasActiveDeposit;
    uint amount;
    uint startTime;
  }

  // Address to investor mapping
  mapping (address => Investor) public investors;

  /**
  * @dev Initializes the bbseTokenContract with the provided contract address.
  * Sets the yearly return rate for the bank.
  * Yearly return rate must be between 1 and 100.
  * Calculates and sets the interest earned per second for a minumum deposit amount
  * based on the yearly return rate.
  * @param _bbseTokenContract address of the deployed BBSEToken contract
  * @param _yearlyReturnRate yearly return rate of the bank
  */
  constructor (address _bbseTokenContract, uint32 _yearlyReturnRate) public {
    bbseTokenContract = BBSEToken(_bbseTokenContract);
    
    // TODO: Check yearly return rate and set the variable
    require(_yearlyReturnRate>=1 && _yearlyReturnRate<=100, "Yearly return rate must be between 1 and 100");
    yearlyReturnRate=_yearlyReturnRate;
    
    
    interestPerSecondForMinDeposit = ((MIN_DEPOSIT_AMOUNT * yearlyReturnRate) / 100) / YEAR_SECONDS;
  }

  /**
  * @dev Initializes the respective investor object in investors mapping for the caller of the function.
  * Sets the amount to message value and starts the deposit time (hint: use block number as the start time).
  * Minimum deposit amount is 1 Ether (be careful about decimals!)
  * Investor can't have an already active deposit.
  */
  function deposit() payable public{
    // TODO: Complete the function
    require(msg.value>=MIN_DEPOSIT_AMOUNT, "Minimum deposit amount is 1 Ether");
    require(investors[msg.sender].hasActiveDeposit==false, "Account can't have multiple active deposits");
    investors[msg.sender].hasActiveDeposit=true;
    investors[msg.sender].amount =msg.value;
    investors[msg.sender].startTime=block.number;
    
  }

  /**
  * @dev Calculates the interest to be paid out based
  * on the deposit amount and duration.
  * Transfers back the deposited amount in Ether.
  * Mints BBSE tokens to investor to pay the interest (1 token = 1 interest).
  * Resets the respective investor object in investors mapping.
  * Investor must have an active deposit.
  */
  function withdraw() public {
    require(investors[msg.sender].hasActiveDeposit==true, "Account must have an active deposit to withdraw");
    Investor storage investor = investors[msg.sender];
    
    // TODO: Uncomment
    uint depositedAmount = investor.amount;

    // TODO: Find the deposit duration and store it in uint depositDuration variable (block_number_difference x average_block_time)
    uint depositDuration=(block.number-investor.startTime)*AVG_BLOCK_TIME;

    // TODO: Uncomment
    uint interestPerSecond = interestPerSecondForMinDeposit * (depositedAmount / MIN_DEPOSIT_AMOUNT);

    // TODO: Calculate the interest using interestPerSecond and depositDuration
    uint interest= interestPerSecond*depositDuration;
   

    /* TODO: Send back the deposited Ether to investor using the transfer method
    *        Dont' forget to cast the investor address to a payable address
    */
    payable (msg.sender).transfer(depositedAmount);
    
    
    // TODO: Mint BBSE tokens to to pay out the interest
    bbseTokenContract.mint(msg.sender, interest);
    
    /* TODO: Reset the respective investor object in investors mapping
    *        You can set the amount and start time to 0
    */
    investor.amount=0;
    investor.hasActiveDeposit=false;
    investor.startTime=0;
  }
  
}
