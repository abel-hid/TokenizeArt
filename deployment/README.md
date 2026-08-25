# Deployment (via Remix + Ethereum Sepolia)

This project is deployed straight from [Remix IDE](https://remix.ethereum.org) —
no Hardhat/Truffle scripts needed. Steps below.

## 0. Prerequisites

- MetaMask installed, with the **Sepolia** test network enabled. Sepolia
  ships built into MetaMask by default — just turn on "Show test networks"
  in Settings > General, or add it manually:
  - Network name: `Sepolia`
  - RPC URL: `https://rpc.sepolia.org`
  - Chain ID: `11155111`
  - Currency symbol: `SepoliaETH`
  - Block explorer: `https://sepolia.etherscan.io`
- Free `SepoliaETH` from a faucet [Google's Sepolia faucet](https://cloud.google.com/application/web3/faucet/ethereum/sepolia).

## 1. Load the contract in Remix

1. Go to remix.ethereum.org.
2. In the File Explorer, create `contracts/FortyTwoNFT.sol`.
3. Paste in the contents of `code/FortyTwoNFT.sol`.
4. Remix will automatically resolve the `@openzeppelin/contracts@5.0.2/...`
   imports over the network the first time you compile — no local install
   required.

## 2. Compile

1. Open the "Solidity Compiler" tab (left sidebar).
2. Set compiler version to `0.8.20` (or any `0.8.x` >= 0.8.20).
3. Click **Compile FortyTwoNFT.sol**. It should compile with no errors.

## 3. Deploy

1. Open the "Deploy & Run Transactions" tab.
2. Set **Environment** to `Injected Provider - MetaMask`.
3. Confirm MetaMask is connected and switched to **Sepolia** (chain id
   11155111).
4. Under **Contract**, select `FortyTwoNFT`.
5. In the constructor field (`initialOwner`), paste your own wallet address.
6. Click **Deploy**, then confirm the transaction in MetaMask.
7. Once mined, copy the deployed contract address from Remix (shown under
   "Deployed Contracts") — you'll need it for minting and for the repo README.

## 4. Verify on Etherscan (optional but recommended)

1. Go to `https://sepolia.etherscan.io/address/<your_contract_address>`.
2. Use "Verify and Publish" (or Remix's built-in Etherscan plugin — paste an
   Etherscan API key, generated free from your Etherscan account) to publish
   the source, so anyone can read the contract on-chain.

## Record here after deploying

- **Contract address:** `0x...`
- **Network:** Ethereum Sepolia (chain id 11155111)
- **Deployer / owner address:** `0x...`
- **Etherscan link:** `https://sepolia.etherscan.io/address/0x...`
