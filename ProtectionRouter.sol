// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

contract ProtectionRouter is Ownable {
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Executes a swap with strict post-execution balance verification
     */
    function protectedSwap(
        address router,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        uint256 deadline
    ) external {
        address tokenIn = path[0];
        address tokenOut = path[path.length - 1];

        // 1. Transfer tokens from user to this contract
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        
        // 2. Approve Router
        IERC20(tokenIn).approve(router, amountIn);

        // 3. Record balance before
        uint256 balanceBefore = IERC20(tokenOut).balanceOf(msg.sender);

        // 4. Perform Swap
        IUniswapV2Router(router).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            msg.sender,
            deadline
        );

        // 5. Verification: Check if the actual received amount meets amountOutMin
        uint256 balanceAfter = IERC20(tokenOut).balanceOf(msg.sender);
        uint256 actualReceived = balanceAfter - balanceBefore;

        require(actualReceived >= amountOutMin, "Protection: Slippage/Sandwich detected");
    }

    function rescueTokens(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner(), balance);
    }
}
