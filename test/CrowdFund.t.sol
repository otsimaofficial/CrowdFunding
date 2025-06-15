// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import {CrowdFund} from "../src/CrowdFund.sol";

contract CrowdFundTest is Test {
    CrowdFund public fund;
    address public owner;
    address public contributor1;
    address public contributor2;

    function setUp() public {
        owner = address(0x1);
        contributor1 = address(0x2);
        contributor2 = address(0x3);

        vm.prank(owner);
        fund = new CrowdFund(5 ether, 1 days, "Build a DApp");

        vm.deal(contributor1, 10 ether);
        vm.deal(contributor2, 10 ether);
    }

    function testContributeIncreasesBalance() public {
        vm.prank(contributor1);
        fund.contribute{value: 2 ether}();
        assertEq(fund.contributions(contributor1), 2 ether);
        assertEq(fund.totalRaised(), 2 ether);
    }

    function testCannotContributeZero() public {
        vm.prank(contributor1);
        vm.expectRevert("Must send ETH");
        fund.contribute{value: 0}();
    }

    function testCannotWithdrawIfNotOwner() public {
        vm.prank(contributor1);
        fund.contribute{value: 5 ether}();

        vm.prank(contributor1);
        vm.expectRevert(CrowdFund.OnlyOwner.selector);
        fund.withdrawFunds();
    }

    function testRefundIfGoalNotMet() public {
        // Travel past deadline
        vm.prank(contributor1);
        fund.contribute{value: 2 ether}();
        vm.warp(block.timestamp + 2 days);

        vm.prank(contributor1);
        fund.refund();
        assertEq(contributor1.balance, 10 ether); // fully refunded
    }

    function testCannotRefundIfGoalMet() public {
        vm.prank(contributor1);
        fund.contribute{value: 5 ether}();
        vm.warp(block.timestamp + 2 days);

        vm.prank(contributor1);
        vm.expectRevert("Goal was met");
        fund.refund();
    }
}
