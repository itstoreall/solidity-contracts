// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Optimized {
    // 1.
    // uint demo; // Gas used: 67066

    // 2.
    // uint demo = 1; // Gas used: 89240

    // 3.
    // uint128 a = 1; //
    // uint128 b = 1; // Gas used: 113512
    // uint256 c = 1; //

    // 4.
    // bytes32 public hash = 0xaa57a70cab00628ed31cb105453febfb466ac9804081bccae9b72daeecd0ebda; // Gas used: 114779

    // 5.
    // mapping(address => uint) payments;

    // function pay() external payable {
    //     require(msg.sender != address(0), "zero address");
    //     payments[msg.sender] = msg.value;
    // } // Gas used: 140017

    // 6.
    // mapping(address => uint) payments;

    // function pay() external payable {
    //     require(msg.sender != address(0), "zero address");
    //     payments[msg.sender] = msg.value;
    // } // Gas used: 23498

    // 7.
    // uint c = 5;
    // uint d;
    // function calc() public {
    //     uint a = 1 + c;
    //     uint b = 2 * c;
    //     d = a + b;
    // } // Gas used: 162071

    // 8.
    uint public result = 1;

    function doWork(uint[] memory data) public {
        uint temp = 1;
        for(uint i = 0; i < data.length; i += 1) {
            temp *= data[i];
        }
        result = temp;
    } // Gas used: 29887
}

contract Unoptimized {
    // 1.
    // uint demo = 0; // Gas used: 69324

    // 2.
    // uint8 demo = 1; // Gas used: 89641

    // 3.
    // uint128 a = 1; // 
    // uint256 c = 1; // Gas used: 135362
    // uint128 b = 1; // 

    // 4.
    // bytes32 public hash = keccak256(
    //     abi.encodePacked("test") // 0xaa57a70cab00628ed31cb105453febfb466ac9804081bccae9b72daeecd0ebda
    // ); // Gas used: 116440

    // 5. 
    // mapping(address => uint) payments;

    // address sender = msg.sender;
    // uint value = msg.value;

    // function pay() external payable {
    //     require(sender != address(0), "zero address");
    //     payments[sender] = value;
    // } // Gas used: 180564

    // 6.
    // uint[] payments;

    // function pay() external payable {
    //     require(msg.sender != address(0), "zero address");
    //     payments.push(msg.value);
    // } // Gas used: 45618

    // 7.
    // uint c = 5;
    // uint d;
    // function calc() public {
    //     uint a = 1 + c;
    //     uint b = 2 * c;
    //     calc2(a, b);
    // }

    // function calc2(uint a, uint b) private {
    //     d = a+ b;
    // } // Gas used: 165101

    // 8.
    uint public result = 1;

    function doWork(uint[] memory data) public {
        for(uint i = 0; i < data.length; i += 1) {
            result *= data[i];
        }
    } // Gas used: 30317
}

// https://youtu.be/EeKKU6zvwuQ