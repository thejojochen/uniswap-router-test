// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Script.sol";
import "../src/SingleSwaps.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyScript is Script {

    address public constant DEPLOYMENT_ADDRESS = 0x1EB928AA2940e6A218B40a2bBe683D63CBD93883;
    address public constant WETH9 = 0x4200000000000000000000000000000000000006;
    address public constant USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F; //WARNING 6 DECIMALS ONLY
    uint24 public constant POOL_FEE_500 = 500; // 0.05%

    

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("OPTIMISM_TESTNET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SingleSwaps routerWrapper = SingleSwaps(DEPLOYMENT_ADDRESS);


        //from testSwapExactInputSingle_WETH_USDC_500()
        require(IERC20(WETH9).approve(address(routerWrapper), type(uint256).max));
        uint256 amountOut = routerWrapper.swapExactInputSingle(1e14 /*determine avg eventually*/, WETH9, USDC, POOL_FEE_500);
        console.log("USDC received: ", amountOut);

        vm.stopBroadcast();
    }
}