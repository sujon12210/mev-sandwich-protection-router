const { ethers } = require("ethers");

async function main() {
    const provider = new ethers.JsonRpcProvider("https://rpc.flashbots.net"); // Private RPC
    const wallet = new ethers.Wallet("YOUR_PRIVATE_KEY", provider);
    
    const routerAddress = "0x..."; // Deployed ProtectionRouter
    const abi = ["function protectedSwap(address, uint256, uint256, address[], uint256)"];
    const contract = new ethers.Contract(routerAddress, abi, wallet);

    console.log("Sending transaction via Private RPC to avoid MEV searchers...");

    const tx = await contract.protectedSwap(
        "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", // Uniswap V2
        ethers.parseUnits("1.0", 18), // 1 Token In
        ethers.parseUnits("0.98", 18), // Min 0.98 Token Out (2% slippage)
        ["0xTokenIn", "0xTokenOut"],
        Math.floor(Date.now() / 1000) + 60 * 10 // 10 min deadline
    );

    await tx.wait();
    console.log("Protected swap completed!");
}

main();
