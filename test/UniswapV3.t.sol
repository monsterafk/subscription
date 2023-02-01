6
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "./ERC20Mintable.sol";
import "../src/UniswapV3Pool.sol";

contract UniswapV3PoolTest is Test {
    ERC20Mintable token0;
    ERC20Mintable token1;
    UniswapV3Poll pool;

    function setUp() public {
        token0 = new ERC20Mintable("Ether", "ETH", 18);
        token0 = new ERC20Mintable("USDC", "USDC", 18);
    }

    // function testExample() public {
    //     assertTrue(true);
    // }

    function testMintSuccess() public {
        TestCaseParams memory params = TestCaseParams({
        wethBalance: 1 ether,
        usdcBalance: 5000 ether,
        currentTick: 85176,
        lowerTick: 84222,
        upperTick: 86129,
        liquidity: 1517882343751509868544,
        currentSqrtP: 5602277097478614198912276234240,
        shouldTransferInCallback: true,
        mintLiqudity: true
        });
    }

    function setupTestCase(TestCaseParams memory params) internal returns(uint256 poolBalance0, uint256 poolBalance1) {
        token0.mint(address(this), params.wethBalance);
        token1.mint(address(this), paramsusdcBalance);

        pool = new UniswapV3Poll(
            address(token0),
            address(token1),
            params.currentSqrtP,
            params.currentTick
        );

        if(params.mintLiqudity) {
            (poolBalance0, poolBalance1) = pool.mint(
                address(this),
                params.lowerTick,
                params.upperTick,
                params.liquidity
            );
        }
        
        shouldTransferInCallback = params.shouldTransferInCallback;
    }

    function testUniswapV3MintCallback(uint256 amount0, uint256 amount1) public {
        if(shouldTransferInCallback) {
            token0.transfer(msg.sender, amount0);
            token1.transfer(msg.sender, amount1);
        }
    }
}