// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Subscription {
    uint256 public priceDef = 1 ether;
    uint256 public pricePrem = 2 ether;
    uint256 public deadline = 31 days;
    address owner;

    error UNDECLARED();

    event NewSubscriber(address indexed subscriber, Type subscriptionType);
    event NewSubPrice(Type subscriptionType, uint256 newPrice);
    

    mapping(address => mapping(Type => uint256)) private _subscriber;
    mapping(address => Type) private _subscribtionType;
    mapping(address => uint256) private _subscriptionDate;
    mapping(address => uint256) private _subscriptionDateEnd;

    enum Type {
        Default,
        Premium
    }


    modifier onlyOwner {
        require(msg.sender == owner, "OWNER");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function buySubsctiption(Type typeSubs) external payable {
        if (typeSubs == Type.Default) {
            require(msg.value == priceDef, "PRICE");

            _subscriber[msg.sender][typeSubs] = block.timestamp;
            _subscribtionType[msg.sender] = typeSubs;
            _subscriptionDate[msg.sender] = block.timestamp;
            _subscriptionDateEnd[msg.sender] = block.timestamp + deadline;

            emit NewSubscriber(msg.sender, typeSubs);

        } else if (typeSubs == Type.Premium) {
            require(msg.value == pricePrem, "PRICE");

            _subscriber[msg.sender][typeSubs] = block.timestamp;
            _subscribtionType[msg.sender] = typeSubs;
            _subscriptionDate[msg.sender] = block.timestamp;

            emit NewSubscriber(msg.sender, typeSubs);
        } else {
            revert UNDECLARED();
        }
    }


    function setNewSubscriptionPrice(
        uint256 newPrice,
        Type subscriptionType
    ) external onlyOwner{
        if(subscriptionType == Type.Default) {

            priceDef = newPrice;

            emit NewSubPrice(subscriptionType, newPrice);

        } else if(subscriptionType == Type.Premium) {

            pricePrem = newPrice;

            emit NewSubPrice(subscriptionType, newPrice);

        } else {
            revert UNDECLARED();
        }
    }

    function checkSubscription(address subcriber) external view returns (
        uint256,
        Type,
        uint256
    ) {
        return (
            _subscriptionDate[subcriber],
            _subscribtionType[subcriber],
            _subscriptionDateEnd[subcriber]
            );
    }

    function withdrawAll() external onlyOwner{
        
    }
}