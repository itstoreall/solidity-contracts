/*
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Functions {
  // public
  // external
  // internal
  // private

  // view (read only)
  // pure

  string message = 'hello!!!'; // state
  uint public balance;

  // fallback function (if the function name doesn't exist)
  fallback() external {
    // code here
  }

  // fallback function (without function for execute)
  receive() external payable {}

  function pay() external payable {
    balance += msg.value;
  }

  // transaction
  function setMessage(string memory newMessage) external {
    message = newMessage;
  }

  // call view
  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  // call view
  function getMessage() external view returns(string memory) {
    return message;
  }

  // call pure
  function rate(uint amount) public pure returns(uint) {
    return amount * 3;
  }
}
*/