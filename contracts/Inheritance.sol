// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
import "./Ownable.sol";

abstract contract Balances is Ownable {
    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

    function withdraw(address payable _to) public override virtual {
        _to.transfer(getBalance());
    } 
}

// 1. hardcoded address
// contract Inheritance is Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), Balances {}

// 2. dynamic address of deployer
// contract Inheritance is Ownable, Balances {
//     constructor() Ownable(msg.sender) {}
// }

// 2. dynamic address of deployer
contract Inheritance is Ownable, Balances {
    constructor(address _owner) Ownable(_owner) {}

    function withdraw(address payable _to) public override(Ownable, Balances) onlyOwner {
        require(_to != address(0), "zero address");
        Balances.withdraw(_to); // the same: super.withdraw(_to);
    } 
}
*/

// https://youtu.be/xkjFcdkAJpg