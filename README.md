# TokenizeArt - FortyTwoNFT

An ERC-721 NFT project built for the 1337/42 TokenizeArt project.

## Platform choice

Several blockchain platforms could support this project, each with real
trade-offs:

- **Ethereum (and its testnets, e.g. Sepolia)** - the original and most
  widely supported smart-contract platform. ERC-721 was defined here.
  Every wallet, explorer (Etherscan), and IPFS/metadata tool assumes
  Ethereum-compatible chains first. Downside: mainnet gas fees are the
  highest of any EVM chain (not a concern on testnet, since it's free).
- **BNB Chain (BSC)** - an EVM-compatible chain, so the same Solidity code
  runs unmodified (BEP-721 is literally the same interface as ERC-721
  under a different name). Cheaper gas on mainnet, but a smaller,
  more centralized validator set and less first-class tooling support than
  Ethereum.
- **Polygon** - another EVM chain, very cheap gas, but adds a second
  network/bridge to reason about for no real benefit at student-project
  scale.
- **Solana / Flow** - non-EVM chains with their own NFT standards
  (Metaplex on Solana, Flow NFT standard). These use different languages
  entirely (Rust, Cadence) and different tooling (no Remix support),
  which would mean learning a whole new ecosystem rather than the
  well-documented ERC-721 standard this subject points toward.

**Chosen: Ethereum Sepolia testnet** (chain id `11155111`). Reasoning:
it's the reference implementation of the standard this project follows
(ERC-721), it has the best-documented tooling (Remix, OpenZeppelin,
Etherscan, IPFS pinning services all target Ethereum first), it's free to
use via public faucets, and using an EVM chain keeps the door open to
redeploy on BSC/Polygon later with zero code changes if needed, since
they're all EVM-compatible.

## Language choice

**Solidity** was chosen over the alternatives:

- **Solidity** (chosen) - the standard language for EVM smart contracts.
  Directly supported by Remix, has the OpenZeppelin library (audited,
  widely used ERC-721 reference implementation) available as a one-line
  import, and is what almost all ERC-721/BEP-721 tutorials and tooling
  assume.
- **Vyper** - a more security-focused, Python-like alternative for the
  EVM. Rejected because it has a much smaller ecosystem, no equivalent to
  OpenZeppelin's battle-tested ERC-721 implementation, and far less
  Remix/tooling support.
- **Rust / Cadence** - required for non-EVM chains (Solana, Flow
  respectively). Rejected along with those chains for the reasons above.
- **EVM** - The Ethereum Virtual Machine (EVM) is a decentralized computation engine that executes smart contracts and updates the state of the Ethereum network. It serves as the runtime environment for decentralized applications (dApps), ensuring that all nodes in the network agree on the outcome of every transaction.

## Other choices made

- **Standard**: ERC-721, via OpenZeppelin's audited base contracts, rather
  than writing the interface from scratch - this keeps the token-transfer/
  approval logic battle-tested and lets the code review focus on the
  project-specific logic (minting, metadata, ownership rules).
- **Tooling**: Remix IDE, using Injected Provider (MetaMask) to deploy
  directly to Ethereum Sepolia - no local Hardhat/Truffle setup needed.
- **Metadata/image storage**: IPFS (via Pinata), satisfying the requirement
  that the image be stored using distributed registry technology.
- **Minting restricted to the contract owner** (`onlyOwner` on `safeMint`),
  to keep control over what enters the collection while leaving token
  transfers themselves fully standard and permissionless.

## Directory structure

```
README.md
code/            -> FortyTwoNFT.sol (the contract)
deployment/      -> step-by-step Remix deployment instructions
mint/            -> minting instructions + example metadata.json
documentation/   -> whitepaper.md, explains architecture & security choices
```

## Deployed contract

- **Address:** _fill in after deploying - see `deployment/README.md`_
- **Network:** Ethereum Sepolia
- **Explorer:** `https://sepolia.etherscan.io/address/<address>`

## Quick start

1. Read `code/FortyTwoNFT.sol`.
2. Follow `deployment/README.md` to deploy via Remix.
3. Follow `mint/README.md` to mint your NFT and confirm ownership via
   `ownerOf`.
4. See `documentation/whitepaper.md` for the full write-up.

