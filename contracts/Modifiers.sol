// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Modifiers {

    address owner;

    constructor(){
        owner = msg.sender;
    }

    function pay() external payable {}

    /* 1.
    modifier onlyOwner() {
        require(msg.sender == owner, 'you are not an owner');
        _;
    }

    function withdraw(address payable _to) external onlyOwner {
        _to.transfer(address(this).balance);
    }
    */

    // /* 2.
    modifier onlyOwner(address _to) {
        require(msg.sender == owner, 'you are not an owner');
        require(_to != address(0), 'incorrect address');
        _;
    }

    function withdraw(address payable _to) external onlyOwner(_to) {
        _to.transfer(address(this).balance);
    }
    // */
}