// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Payments {
  struct Payment {
    uint amount;
    uint timestamp;
    address from;
    string message;
  }

  struct Balance {
    uint totalPayments;
    mapping(uint => Payment) payments;
  }

  mapping(address => Balance) public balances;

  function currentBalance() public view returns(uint) {
    return address(this).balance;
  }

  function getPayment(address _address, uint _index) public view returns(Payment memory) {
    return balances[_address].payments[_index];
  }

  function pay(string memory message) public payable {
    uint paymentNumber = balances[msg.sender].totalPayments;
    balances[msg.sender].totalPayments++;

    Payment memory newPayment = Payment(
      msg.value,
      block.timestamp,
      msg.sender,
      message
    );

    balances[msg.sender].payments[paymentNumber] = newPayment;
  }
}