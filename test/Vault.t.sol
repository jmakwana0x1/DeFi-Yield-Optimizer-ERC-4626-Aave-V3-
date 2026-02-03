//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "../src/mocks/MockUSDC.sol";

contract VaultTest is Test{
    YieldVault vault;
    MockUSDC usdc;  

    address user = address(0x1);

    function setUp()public {
        usdc= new MockUSDC();
        vault = new YieldVault(usdc);
        usdc.mint(user,1_000_000e6); // Mint 1,000,000 USDC to user
        vm.prank(user);
        usdc.approve(address(vault), type(uint256).max);
    }

   function testDeposit() public {
    vm.prank(user);
    vault.deposit(100_000e6, user);

    uint256 expectedShares = vault.convertToShares(100_000e6);
    
    assertEq(vault.balanceOf(user), expectedShares);
    assertEq(vault.totalAssets(), 100_000e6);
}

  function testWithdraw() public {
        vm.startPrank(user);
        vault.deposit(100_000e6, user);
        vault.withdraw(50_000e6, user, user);
        vm.stopPrank();

        assertEq(usdc.balanceOf(user), 950_000e6);
        assertEq(vault.totalAssets(), 50_000e6);
    }

}