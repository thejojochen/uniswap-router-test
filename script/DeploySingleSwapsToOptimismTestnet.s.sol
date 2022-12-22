// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Script.sol";
import "../src/SingleSwaps.sol";

contract MyScript is Script {

    address public constant V3_ROUTER_ADDRESS = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("OPTIMISM_TESTNET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SingleSwaps swapWrapper = new SingleSwaps(V3_ROUTER_ADDRESS);

        vm.stopBroadcast();
    }
}