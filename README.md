# uniswap-router-test

Work in Progress

Approximate Gas Units for Swaps Executed Against Uniswap V3

Run Tests to See Gas Reports:

1. clone repository
2. install foundry https://book.getfoundry.sh/getting-started/installation#on-linux-and-macos
3. run `forge test --fork-url <YOUR_RPC_URL> --gas-report --match-contract TestSingleSwaps --match-test "testSwapExactInputSingle_USDC_WETH_500()"`
3a. change --match-test to desired test if needed (found in test/TestSingleSwaps.t.sol)
3b. to get overall report, run `forge test --fork-url <YOUR_RPC_URL> --gas-report`

# Future Improvement Directions

* better precision for SingleSwaps.swapExactInputSingle()
* gas reports for SingleSwaps.swapExactOutputSingle
* multihop swaps
* dapp integration evironment using ethers.js gas reports
* multicall analysis
* add more pairs
* add more pools
