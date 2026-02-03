//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockAavePool{
    IERC20 public immutable asset;

    constructor(address _asset){
        asset = IERC20(_asset);
    }
    

    function supply(
        address,
        uint256 amount,
        address onBehalfOf,
        uint16
    )external{
        //pull funds from starategy 
        asset.transferFrom(msg.sender, address(this), amount);
        //simulate aToken mint by holding funds on behalf of strategy
        // asset.transfer(onBehalfOf, amount);

    }

    function withdraw(
        address,
        uint256 amount,
        address to 
    )external returns(uint256){
        asset.transfer(to,amount);
        return amount;
    }
    
}