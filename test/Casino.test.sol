// SPDX-License-Identifier: MIT

import "forge-std/Test.sol";
import "../src/Casino.sol";

pragma solidity ^0.8.17;

contract CasinoTest is Test {
    Casino casino;
    address player = vm.addr(1);
    address player1 = vm.addr(2);

    function setUp() public {
        casino = new Casino();
    }

    function testFail_addToBL() public {
        vm.prank(player);
        casino.addToBL(player1);
    }

    function test_addToBL() public {
        casino.addToBL(player1);
    }

    function test_toUp() public {
        (bool succes, ) = address(casino).call{value: 1000000000000000000}("");

        uint256 casBal = address(casino).balance;

        assertEq(casBal, 1 ether);   
    }

}