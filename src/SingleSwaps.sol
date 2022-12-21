// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract SingleSwaps {
    // For the scope of these swap examples,
    // we will detail the design considerations when using
    // `exactInput`, `exactInputSingle`, `exactOutput`, and  `exactOutputSingle`.

    // It should be noted that for the sake of these examples, we purposefully pass in the swap router instead of inherit the swap router for simplicity.
    // More advanced example contracts will detail how to inherit the swap router safely.

    ISwapRouter public immutable swapRouter;



    constructor(address _V3RouterAddress) {
        //swapRouter = _swapRouter; // original
        swapRouter = ISwapRouter(_V3RouterAddress);
    }

    /// @notice swapExactInputSingle swaps a fixed amount of input for a maximum possible amount of output
    /// @dev The calling address must approve this contract to spend at least `amountIn` worth of its input for this function to succeed.
    /// @param amountIn The exact amount of input that will be swapped for output.
    /// @return amountOut The amount of token received.
    function swapExactInputSingle(uint256 amountIn, address tokenToSpend, address tokenToRecieve, uint24 poolFee) external returns (uint256 amountOut) {
        // msg.sender must approve this contract *****************

        // Transfer the specified amount of input to this contract.
        TransferHelper.safeTransferFrom(tokenToSpend, msg.sender, address(this), amountIn);

        // Approve the router to spend input.
        TransferHelper.safeApprove(tokenToSpend, address(swapRouter), amountIn);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenToSpend,
                tokenOut: tokenToRecieve,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }

    ///no tested yet 
    /// see uniswap docs
    function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum, address tokenToSpend, address tokenToRecieve, uint24 poolFee) external returns (uint256 amountIn) {
        
        //approve this contract first ?
        TransferHelper.safeTransferFrom(tokenToSpend, msg.sender, address(this), amountInMaximum);

        // Approve the router to spend the specifed `amountInMaximum` of DAI.
        // In production, you should choose the maximum amount to spend based on oracles or other data sources to acheive a better swap.
        TransferHelper.safeApprove(tokenToSpend, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: tokenToSpend,
                tokenOut: tokenToRecieve,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(tokenToSpend, address(swapRouter), 0);
            TransferHelper.safeTransfer(tokenToSpend, msg.sender, amountInMaximum - amountIn);
        }
    }
}