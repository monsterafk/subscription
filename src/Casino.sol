// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import './ICasino.sol';

contract Casino is ICasino {
    uint public casinoBalance;
    // uint private casinoNonce;
    address public owner;
    
    // mapping(address => uint) private nonceUser;
    mapping(address => uint) public balances;
    mapping(address => bool) public blackList;

    modifier onlyOwner {
        require(msg.sender == owner, "you a not an owner");
        _;
    }

    constructor() payable {
        owner = msg.sender;
        casinoBalance = msg.value;
    }

    // бросить кости
    // на данный момент постоянно выигрывает игрок, а не казино =) не хочу использовать чейнлинк для рандома
    function RollTheDice() public payable {
        require(!blackList[msg.sender], "You are blacklisted");

        uint yourPoints = _roll1();
        uint casinoPoints = _roll2();

        // nonceUser[msg.sender]++;
        // casinoNonce++;

        if (yourPoints < casinoPoints) {
            emit Loser(msg.sender, casinoPoints, msg.value);

            balances[msg.sender] -= msg.value;
        } else if (yourPoints > casinoPoints) {
            balances[msg.sender] += msg.value * 3;

            emit Winner(msg.sender, yourPoints, msg.value * 3);

        } else if (yourPoints == casinoPoints) {
            emit Draw(msg.sender);

            balances[msg.sender] += msg.value;
        }
    }

    function _roll1() private returns (uint) {
        // uint points = nonceUser[msg.sender] / 13;
        uint points = block.timestamp / 213;

        emit AmountDropped(msg.sender, points);
        return points;
    }

    function _roll2() private returns (uint) {
        // uint points =  casinoNonce / 13;
        uint points = casinoBalance / 400;


        emit AmountDropped(address(this), points);
        return points;
    }

    function SpinTheDrum(string memory color) external payable {
        emit CollorDropped(msg.sender, color);
    }

    // блок юзера
    function addToBL(address intruder) external onlyOwner{
        require(!blackList[intruder]);

        emit addToBlackList(intruder);

        casinoBalance += balances[msg.sender];

        blackList[intruder] = true;
    }

    function withdraw(uint amount) external override{
        require(balances[msg.sender] >= amount, "Not enough funds");
        require(!blackList[msg.sender], "You in bl");

        balances[msg.sender] -= amount;
        casinoBalance -= amount;

        payable(msg.sender).transfer(amount);

    }

    //пополнить баланс казино
    function toUp() external payable onlyOwner{
        casinoBalance += msg.value;
    }

    receive() external payable {
        RollTheDice();
    }
}