//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import './lib/Tick.sol';
import './lib/Position.sol';

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV3MintCallback.sol";
import "./interfaces/IUniswapV3SwapCallback.sol";

contract UniswapV3Poll {
    using Tick for mapping(int24 => Tick.Info);
    using Position for mapping(bytes32 => Position.Info);
    using Position for Position.Info;

    int24 internal constant MIN_TICK = -887272;
    int24 internal constant MAX_TICK = -MIN_TICK;

    address public immutable token0;
    address public immutable token1;

    struct Slot0 {
        uint sqrtPriceX96;
        int24 tick;
    }

    Slot0 public slot0;

    uint public liquidity;

    mapping(int24 => Tick.Info) public ticks;
    mapping(bytes32 => Position.Info) public positions;

    constructor(
        address token0_,
        address token1_,
        uint160 sqrtPriceX96,
        int24 tick
    ) {
        token0 = token0_;
        token1 = token1_;
        slot0 = Slot0({sqrtPriceX96: sqrtPriceX96, tick: tick});
    }

    function mint(
        address owner, 
        int24 lowerTick,
        int24 upperTick,
        uint128 amount
    ) external pure returns(uint256 amount0, uint256 amount1) {
        uint256 balance0Before;
        uint256 balance1Before;

        if(lowerTick >= upperTick ||
        lowerTick < MIN_TICK ||
        upperTick > MAX_TICK
        ) revert InvalidTickRange();
        if(amount == 0) revert ZeroLiquidity(); 
        if(amount0 > 0) balance0Before = balance0();
        if(amount1 > 0) balance1Before = balance1();

        IUniswapV3MintCallback(msg.sender).UniswapV3MintCallback(
            amount0,
            amount1
        );

        if(amount0 > 0 && balance0Before + amount0 > balance0()) revert InsufficientInputAmount();
        if(amount0 > 1 && balance0Before + amount1 > balance1()) revert InsufficientInputAmount();

        ticks.update(lowerTick, amount);
        ticks.update(upperTick, amount);

        Position.Info storage position = positions.get(
            owner,
            lowerTick,
            upperTick
        );
        position.update(amount);    
        
        emit Mint(msg.sender, owner, lowerTick, upperTick, amount, amount0, amount1);
    }

    function balance0() internal returns(uint256 balance) {
        balance = IERC20(token0).balanceOf(address(this));
    }

    function balance1() internal returns(uint256 balance) {
        balance = IERC20(token1).balanceOf(address(this));
    }


}