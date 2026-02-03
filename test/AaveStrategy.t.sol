//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {Test} from "forge-std/Test.sol";
import {YieldVault} from "../src/Vault.sol";
import {MockUSDC} from "../src/mocks/MockUSDC.sol";
import {AaveStrategy} from "../src/strategies/AaveStrategy.sol";
import {IPool} from "../src/interfaces/IPool.sol";
import {MockAavePool} from "../src/mocks/MockAavePool.sol";

contract AaveStrategyTest is Test{
    MockUSDC usdc;
    MockAavePool aavePool;
    AaveStrategy strategy;

    address vault = address(0x11111);

    function setUp()public{
        usdc= new MockUSDC();
        aavePool = new MockAavePool(address(usdc));
        strategy = new AaveStrategy(address(usdc), address(aavePool), vault);

        //Mint USDC to Vault 
        usdc.mint(vault,100_000e6);

        //Vault sends funds to strategy
        vm.prank(vault);
        
        usdc.transfer(address(strategy),100_000e6);
    }

    function testDeployAndWithdraw() public {
    // --- deploy ---
        vm.prank(vault);
        strategy.deploy(100_000e6);

        assertEq(usdc.balanceOf(address(strategy)), 0);
        assertEq(usdc.balanceOf(address(aavePool)), 100_000e6);

        // --- withdraw ---
        vm.prank(vault);
        strategy.withdraw(50_000e6);

        assertEq(usdc.balanceOf(vault), 50_000e6);
        assertEq(usdc.balanceOf(address(aavePool)), 50_000e6);
}

    

}