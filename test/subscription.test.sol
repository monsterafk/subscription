// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import '../src/subscription.sol';
import "forge-std/Test.sol";

contract SubscriptionTest is Test {
    Subscription subs;

    address buyer = vm.addr(1);
    address third = vm.addr(2);

    function setUp() public {
        subs = new Subscription();
    }

    function test_buySubsctiption() public {

        subs.buySubsctiption{value: 1 ether }(Subscription.Type.Default);
    }

    function testFail_buySubsctiption() public {
        subs.buySubsctiption{value: 2 ether }(Subscription.Type.Default);
    
        vm.expectRevert("PRICE");
    }

    function test_buySubsctiption2() public {
        subs.buySubsctiption{value: 2 ether }(Subscription.Type.Premium);
    }

    function testFail_setNewSubscriptionPrice() public {
        vm.prank(buyer);

        subs.setNewSubscriptionPrice(11, Subscription.Type.Default);

        vm.expectRevert("OWNER");
    }

    function test_setNewSubscriptionPrice() public {
        subs.setNewSubscriptionPrice(11, Subscription.Type.Default);

        (bool success, ) = buyer.call{value: 10 ether}("");

        vm.prank(buyer);

        subs.buySubsctiption{value: 11 }(Subscription.Type.Default);
    }

    function test_checkSubscription() public {
        (bool success, ) = buyer.call{value: 10 ether}("");

        vm.prank(buyer);

        subs.buySubsctiption{value: 1 ether }(Subscription.Type.Default);

        subs.checkSubscription(buyer);
    }

    function test_checkSubscriptionNo() public {

        subs.checkSubscription(third);

    }

}