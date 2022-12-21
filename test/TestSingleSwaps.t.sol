// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Test.sol";
import "../src/SingleSwaps.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TestSingleSwaps is Test {

    SingleSwaps public routerWrapper;
    address public constant V3_ROUTER_ADDRESS = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    uint24 public constant POOL_FEE_3000 = 3000; //0.3%
    uint24 public constant POOL_FEE_100 = 100; // 0.01 %
    uint24 public constant POOL_FEE_500 = 500; // 0.05%

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //WARNING 6 DECIMALS ONLY
    address public constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599; //https://etherscan.io/token/0x2260fac5e5542a773aa44fbcfedf7c193bc2c599 //WARNING 8 DECIMALS ONLY
    address public constant MATIC = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0; //https://etherscan.io/token/0x7d1afa7b718fb893db30a3abc0cfc608aacfebb
    address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7; //https://etherscan.io/token/0xdac17f958d2ee523a2206206994597c13d831ec7 //WARNING 6 DECIMALS ONLY

    address public constant DAI_WHALE = 0x075e72a5eDf65F0A5f44699c7654C1a76941Ddc8; //https://etherscan.io/token/0x6b175474e89094c44da98b954eedeac495271d0f#balances
    address public constant WETH_WHALE = 0xF04a5cC80B1E94C69B48f5ee68a08CD2F09A7c3E; //https://etherscan.io/token/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2#balances
    address public constant USDC_WHALE = 0x0A59649758aa4d66E25f08Dd01271e891fe52199; //https://etherscan.io/token/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48#balances
    address public constant WBTC_WHALE = 0x9ff58f4fFB29fA2266Ab25e75e2A8b3503311656; //https://etherscan.io/token/0x2260fac5e5542a773aa44fbcfedf7c193bc2c599#balances
    address public constant MATIC_WHALE = 0x5e3Ef299fDDf15eAa0432E6e66473ace8c13D908; //https://etherscan.io/token/0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0#balances
    address public constant USDT_WHALE = 0x5754284f345afc66a98fbB0a0Afe71e0F007B949; //https://etherscan.io/token/0xdac17f958d2ee523a2206206994597c13d831ec7#balances

    function setUp() public {
        routerWrapper = new SingleSwaps(V3_ROUTER_ADDRESS); //address of v3 router https://docs.uniswap.org/contracts/v3/reference/deployments
    }

    //notes
    //gas reports do not include approving the router contract
    //gas reports do not include wrapping ether (assumes caller of router already has WETH)

    //example command:
    //forge test --fork-url <YOUR_ENDPOINT_URL> --gas-report --match-contract TestSingleSwaps --match-test testSwapExactInputSingle_DAI_USDC_100

    function testSwapExactInputSingle_DAI_USDC_100() public { 
        vm.startPrank(DAI_WHALE);  //all subsequent calls
        require(IERC20(DAI).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e18 /*determine avg eventually*/, DAI, USDC, POOL_FEE_100);
        console.log("USDC received: ", amountOut);
    }
    function testSwapExactInputSingle_USDC_DAI_100() public {
        vm.startPrank(USDC_WHALE);  //all subsequent calls
        require(IERC20(USDC).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e6 /*determine avg eventually*/, USDC, DAI, POOL_FEE_100);
        console.log("DAI received: ", amountOut);
    }
    //

    function testSwapExactInputSingle_USDC_WETH_500() public {
        vm.startPrank(USDC_WHALE);  //all subsequent calls
        require(IERC20(USDC).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e6 /*determine avg eventually*/, USDC, WETH9, POOL_FEE_500);
        console.log("WETH received: ", amountOut);
    }
    function testSwapExactInputSingle_WETH_USDC_500() public {
        vm.startPrank(WETH_WHALE);  //all subsequent calls
        require(IERC20(WETH9).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e18 /*determine avg eventually*/, WETH9, USDC, POOL_FEE_500);
        console.log("USDC received: ", amountOut);
    }
    //
    function testSwapExactInputSingle_WBTC_WETH_500() public {
        vm.startPrank(WBTC_WHALE);  //all subsequent calls
        require(IERC20(WBTC).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e8 /*determine avg eventually*/, WBTC, WETH9, POOL_FEE_500);
        console.log("WETH received: ", amountOut);
    }
    function testSwapExactInputSingle_WETH_WBTC_500() public {
        vm.startPrank(WETH_WHALE);  //all subsequent calls
        require(IERC20(WETH9).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e18 /*determine avg eventually*/, WETH9, WBTC, POOL_FEE_500);
        console.log("WBTC received: ", amountOut);
    }
    //
    function testSwapExactInputSingle_MATIC_WETH_3000() public {
        vm.startPrank(MATIC_WHALE);  //all subsequent calls
        require(IERC20(MATIC).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e18 /*determine avg eventually*/, MATIC, WETH9, POOL_FEE_3000);
        console.log("WETH received: ", amountOut);
    }
    function testSwapExactInputSingle_WETH_MATIC_3000() public {
        vm.startPrank(WETH_WHALE);  //all subsequent calls
        require(IERC20(WETH9).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e18 /*determine avg eventually*/, WETH9, MATIC, POOL_FEE_3000);
        console.log("MATIC received: ", amountOut);
    }
    //
    function testSwapExactInputSingle_USDC_USDT_100() public {
        vm.startPrank(USDC_WHALE);  //all subsequent calls
        require(IERC20(USDC).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e6 /*determine avg eventually*/, USDC, USDT, POOL_FEE_100);
        console.log("USDT: ", amountOut);
    }
    function testSwapExactInputSingle_USDT_USDC_100() public {
        vm.startPrank(USDT_WHALE);  //all subsequent calls
        SafeERC20.safeApprove(IERC20(USDT), address(routerWrapper), type(uint256).max); //**** you usdt
        uint256 amountOut = routerWrapper.swapExactInputSingle(5e6 /*determine avg eventually*/, USDT, USDC, POOL_FEE_100);
        console.log("USDC received: ", amountOut);
    }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
