// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Script.sol";
import "../src/SingleSwaps.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyScript is Script {

    address public constant DEPLOYMENT_ADDRESS = 0x3fd1Eea629fbec3cd2F7A07135cb813BfeB30105;
    address public constant WETH9 = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address public constant USDC = 0xd35CCeEAD182dcee0F148EbaC9447DA2c4D449c4; //WARNING 6 DECIMALS ONLY
    uint24 public constant POOL_FEE_500 = 500; // 0.05%

    

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("GOERLI_TESTNET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SingleSwaps routerWrapper = SingleSwaps(DEPLOYMENT_ADDRESS);


        //from testSwapExactInputSingle_WETH_USDC_500()
        require(IERC20(WETH9).approve(address(routerWrapper), type(uint256).max));

        require(IERC20(WETH9).transferFrom(0xc872647FDdC071709D1B4FDF12a5a4FD98946910, address(routerWrapper), 1e14), "transfer failed");

        uint256 amountOut = routerWrapper.swapExactInputSingle(1e12 /*determine avg eventually*/, WETH9, USDC, POOL_FEE_500);

        
        console.log("allowance: ", IERC20(WETH9).allowance(0xc872647FDdC071709D1B4FDF12a5a4FD98946910, address(routerWrapper)));
        console.log("USDC received: ", amountOut);

        vm.stopBroadcast();
    }
}