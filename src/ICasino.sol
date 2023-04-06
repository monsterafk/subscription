// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface ICasino {
    event addToBlackList(address indexed intruder);
    event Loser(address indexed supplier, uint numberOfWinner, uint indexed bid);
    event Winner(address indexed supplier, uint numberOfWinner, uint indexed prize);
    event AmountDropped(address indexed player, uint indexed quiantityPoints);
    event CollorDropped(address indexed player, string indexed color);
    event Draw(address indexed player);

    function RollTheDice() external payable;
    function SpinTheDrum(string memory color) external payable;
    function withdraw(uint amount) external;
    function addToBL(address intruder) external;
    function toUp() external payable;
}