// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// contract MemoryCalldata {
//     function memoryString(string memory /*_str*/) external pure returns(bytes32 data) {
//         assembly {
//             let ptr := mload(64) // "test" -> ptr 192

//             // sub() - функція віднімання
//             data := mload(sub(ptr, 32)) // bytes32: data 0x7465737400000000000000000000000000000000000000000000000000000000
//         }
//     }

//     // ---

//     function memoryArray(uint[3] memory /*_arr*/) external pure returns(bytes32 data) {
//         assembly {
//             let ptr := mload(64)

//             // sub() - функція для віднімання
//             data := mload(sub(ptr, 64)) // bytes32: data 0x0000000000000000000000000000000000000000000000000000000000000002
//         }
//     }

//     // ---

//     function callData(uint[3] memory /*_arr*/) external pure returns(bytes memory) {
//         return msg.data; // bytes: 0x04a32fc0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003
//     }

//     // Selector --- 

//     function sel() external pure returns(bytes4) {
//         return bytes4(keccak256(bytes("work(uint256[3])"))); // 0x1c28968b
//     }

//     function work(uint[3] memory /*_arr*/) external pure returns(bytes4) {
//         return bytes4(msg.data[0:4]); // if [1,2,3] -> 0x1c28968b
//     }

//     function readFromString(string calldata /*_str*/) external pure returns(bytes32 _el1) {
//         assembly {
//             // _el1 := calldataload(4)
//             // bytes32: _el1 0x0000000000000000000000000000000000000000000000000000000000000020

//             // _el1 := calldataload(add(4, 32)) // add() - функція додавання
//             // bytes32: _el1 0x0000000000000000000000000000000000000000000000000000000000000004 -> (4 bytes) - str.length

//             _el1 := calldataload(add(4, 64)) // add() - функція додавання
//             // bytes32: _el1 0x7465737400000000000000000000000000000000000000000000000000000000 = "test" (string)
//         }
//     }

//     function readFromArray(uint[3] calldata /*_arr*/) external pure returns(bytes32 _el1) {
//         assembly {
//             _el1 := calldataload(4)
//         } // bytes32: _el1 0x0000000000000000000000000000000000000000000000000000000000000001
//     }

//     // Dynamic array ---

//     function readFromDynamicArray(uint[] calldata /*_dynArr*/) external pure returns(bytes32 _startIn, bytes32 _elCount, bytes32 _firstElOfArray) {
//         assembly {
//             _startIn := calldataload(4)
//             _elCount := calldataload(add(_startIn, 4))
//             _firstElOfArray := calldataload(add(_startIn, 68)) // 2
//             // _firstElOfArray := calldataload(add(_startIn, 36)) // 1
//         } 

//         // bytes32: _startIn 0x0000000000000000000000000000000000000000000000000000000000000020
//         // bytes32: _elCount 0x0000000000000000000000000000000000000000000000000000000000000003
//         // bytes32: _firstElOfArray 0x0000000000000000000000000000000000000000000000000000000000000002
//     }
// }

// https://youtu.be/xsV9FkDKcJY