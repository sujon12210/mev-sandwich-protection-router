# MEV Sandwich Protection Router

This repository provides a professional solution for users and dApps to defend against "Sandwich Attacks." These attacks occur when a searcher spots a pending swap and places a transaction before and after it to profit from the resulting price slippage.

## How It Works
- **Atomic Enforcement**: Checks the balance before and after the swap within the same transaction.
- **Strict Slippage**: Reverts the transaction if the output is even one wei below the calculated minimum, bypassing the flexible slippage of public DEXs.
- **Private RPC Support**: Integration helpers for sending transactions via private builders (like Flashbots or BloXroute) to keep orders out of the public mempool.

## Protection Strategy
1. **No Mempool Exposure**: Encourages use of `eth_sendBundle` or private RPCs.
2. **Min-Return Verification**: Validates `amountOut` manually to ensure the DEX router didn't execute at a manipulated price.



## Prerequisites
- Solidity ^0.8.20
- Ethers.js for client-side signing
