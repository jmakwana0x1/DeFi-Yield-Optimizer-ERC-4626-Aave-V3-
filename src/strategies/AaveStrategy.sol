// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "../interfaces/IPool.sol";
contract AaveStrategy is ReentrancyGuard {
    IERC20 public immutable asset;
    IPool public immutable aavePool;
    address public immutable vault;

    modifier onlyVault() {
        require(msg.sender == vault, "NOT_VAULT");
        _;
    }

    constructor(
        address _asset,
        address _aavePool,
        address _vault
    ) {
        asset = IERC20(_asset);
        aavePool = IPool(_aavePool);
        vault = _vault;

        asset.approve(_aavePool, type(uint256).max);
    }

    /// @notice Deploy funds to Aave
    function deploy(uint256 amount) external onlyVault nonReentrant {
        require(amount > 0, "ZERO_AMOUNT");
        aavePool.supply(address(asset), amount, address(this), 0);
    }

    /// @notice Withdraw funds back to vault
    function withdraw(uint256 amount) external onlyVault nonReentrant {
        require(amount > 0, "ZERO_AMOUNT");
        aavePool.withdraw(address(asset), amount, vault);
    }

    /// @notice Total assets deployed + idle
    function totalAssets() external view returns (uint256) {
        return asset.balanceOf(address(this));
    }
}
