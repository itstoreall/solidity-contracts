/*
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Errors {
  // require
  // revert
  // assert

  address owner;

  constructor(){
    owner = msg.sender;
  }

  function pay() external payable {}

  function withdraw(address payable _to) external {
    // 1.
    // assert(msg.sender == owner); // (panic) use carefully

    // 2.
    require(msg.sender == owner, 'you are not an owner'); // (error) if condition is false the tx will be stoped, and the string will shown

    // 3.
    // if(msg.sender != owner) {
    //   revert('you are not an owner'); // (error) revert is the same as require, but using if
    // }

    _to.transfer(address(this).balance);
  }
}
*/