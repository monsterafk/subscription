// // SPDX-License-Identifier: Apache-2.0
// pragma solidity ^0.8.18;

// contract Wallet{
//     address public owner;
//     uint256 public balance;
    
//     struct History{
//         uint256 txOut;
//         bool blocked;
//     }

//     History public story;

//     constructor() {
//         owner = msg.sender;
//     }

//     modifier onlyOwner() {
//         require(msg.sender == owner);
//         _;
//     }

//     function tx(address payable to) external payable onlyOwner {
//         require(to != msg.sender, "You cant tx you");

//         to.transfer(msg.value);
//         story.txOut += 1;
//         balance += msg.value;
//     }

//     receive() external payable {
//         balance += msg.value;
//     }

//     function destroy(address _to) private {
//         selfdestruct(payable(_to));
//     }
// }