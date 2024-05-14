// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import "@dependencies/DeployTypes.sol";


contract ExchangeTest is Test {
    DeployTypes.DeployedContracts contracts;

    Exchange exchange;
    Token token;

    address owner = makeAddr("owner");
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address alex = makeAddr("user");

    uint256 mintETH = 100e18;
    uint256 mintToken = 50000e18;

    function setUp() public {
        deal(owner, mintETH);
        deal(alice, mintETH);
        deal(bob, mintETH);
        deal(alex, mintETH);

        vm.startPrank(owner);    
        token = new Token();
        exchange = new Exchange(address(token));
        vm.stopPrank();

        token.mint(alice, mintToken);
        token.mint(bob, mintToken);
    }

    function test_general() external {
// add Liquidity 
        vm.startPrank(owner);    
        token.approve(address(exchange), 100000e18);
        exchange.addLiquidity{value: 10e18}(100000e18);
        vm.stopPrank();
        // Exchange pool
        //  ETH   /   Token   /  LPT
        // 10e18  / 100000e18 / 10e18

        vm.startPrank(alice);    
        token.approve(address(exchange), mintToken);
        exchange.addLiquidity{value: 3e18}(mintToken);
        vm.stopPrank();
        // Exchange pool
        //  ETH   /   Token   /  LPT
        // 13e18  / 130000e18 / 13e18

        vm.startPrank(bob);    
        token.approve(address(exchange), 30000e18);
        exchange.addLiquidity{value: 3e18}(30000e18);
        vm.stopPrank();
        // Exchange pool
        //  ETH   /   Token   /  LPT
        // 16e18  / 160000e18 / 16e18

// removeLiquidity
        vm.startPrank(bob);    
        exchange.removeLiquidity(1e18);
        vm.stopPrank();
        // Exchange pool
        //  ETH   /   Token   /  LPT
        // 15e18  / 150000e18 / 15e18

// ethToTokenSwap
        console.log("ETH balance before swap", alex.balance);
        console.log("Token balance before swap", token.balanceOf(address(alex)));
        vm.startPrank(alex);    
        exchange.ethToTokenSwap{value: 1e18}(0);
        vm.stopPrank();
        console.log("ETH balance after swap", alex.balance);
        console.log("Token balance after swap", token.balanceOf(address(alex)));
        console.log("-----------------------------------------------");

// tokenToEthSwap
        console.log("ETH balance before swap", bob.balance);
        console.log("Token balance before swap", token.balanceOf(address(bob)));
        vm.startPrank(bob);    
        token.approve(address(exchange), 30000e18);
        exchange.tokenToEthSwap(30000e18, 0);
        vm.stopPrank();
        console.log("ETH balance after swap", bob.balance);
        console.log("Token balance after swap", token.balanceOf(address(bob)));
    }
}