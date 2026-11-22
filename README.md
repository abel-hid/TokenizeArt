# TokenizeArt - FortyTwoNFT

**FortyTwoNFT** (`FortyTwoArt`, symbol `F42`) is an ERC-721 NFT collection
built for the 1337 / 42 Network **TokenizeArt** project. Each token is a
one-of-a-kind artwork that includes the number **42**. The image and its
metadata are stored on **IPFS**, and ownership is recorded on the
**Ethereum Sepolia** testnet.

> **In one sentence:** the contract owner mints a token that points to a
> metadata file on IPFS, and from then on anyone can check on-chain who owns
> it by calling `ownerOf(tokenId)`.

---

## Table of contents

1. [What an NFT is, in this project](#what-an-nft-is-in-this-project)
2. [How it works](#how-it-works)
3. [The smart contract](#the-smart-contract)
4. [Security and privileges](#security-and-privileges)
5. [Technical choices](#technical-choices)
6. [Repository structure](#repository-structure)
7. [Quick start](#quick-start)
8. [Deployed contract](#deployed-contract)
9. [Glossary](#glossary)

---

## What an NFT is, in this project

An NFT (Non-Fungible Token) is a unique token on a blockchain. Unlike a
cryptocurrency, where every coin is the same as every other, each NFT has its
own ID and exactly one owner at a time.

In FortyTwoNFT, every token has three parts:

| Part | Where it lives | What it holds |
|---|---|---|
| **Token** (ID + owner) | On-chain, in the smart contract on Sepolia | Who owns token #N |
| **Metadata** (JSON) | IPFS | `name`, `description`, `image`, `attributes` |
| **Image** | IPFS | The artwork itself, which includes the number 42 |

The contract stores only a link (the **token URI**) to the metadata, not the
image itself. Storing images on-chain would be very expensive, and IPFS
addresses files by the hash of their content, so the link cannot be quietly
changed to point at a different file.

## How it works

```
  ┌──────────────┐   1. upload    ┌───────────────────────────┐
  │  Artwork     │ ─────────────▶ │  IPFS (Pinata)            │
  │  (has "42")  │                │  image      -> CID_img    │
  └──────────────┘                │  metadata   -> CID_meta   │
                                  │  meta.image = CID_img     │
                                  └─────────────┬─────────────┘
                                                │ 2. tokenURI = ipfs://CID_meta
                                                ▼
  ┌──────────────┐  3. safeMint(to, uri)  ┌───────────────────────────┐
  │  Contract    │ ─────────────────────▶ │  FortyTwoNFT on Sepolia   │
  │  owner       │   (signed in MetaMask) │  token #0 -> owner: `to`  │
  └──────────────┘                        │  token #0 -> tokenURI     │
                                          └─────────────┬─────────────┘
                                                        │ 4. read (free)
                                                        ▼
                                   ownerOf(0)   -> 0xOwnerAddress
                                   tokenURI(0)  -> ipfs://CID_meta -> image
```

1. **Create** an image that includes the number 42 and upload it to IPFS.
2. **Describe** it in a metadata JSON file (see [mint/metadata.json](mint/metadata.json)) whose
   `image` field points to the image's IPFS link, then upload that JSON to
   IPFS as well. Its link becomes the token URI.
3. **Mint**: the contract owner calls `safeMint(to, uri)`. The contract gives
   the token the next ID (starting at `0`), assigns it to `to`, stores the
   URI, and emits an `NFTMinted` event.
4. **Verify**: anyone can call `ownerOf(tokenId)` to see who owns the token
   and `tokenURI(tokenId)` to find its metadata and image. These are free
   read-only calls.

## The smart contract

Source: [code/FortyTwoNFT.sol](code/FortyTwoNFT.sol). It is built on audited
OpenZeppelin **v5.0.2** contracts:

| Inherits from | Purpose |
|---|---|
| `ERC721` | The standard NFT logic: ownership, transfers, approvals |
| `ERC721URIStorage` | A separate metadata URI for each token, since every artwork is different |
| `Ownable` | One owner address that holds the minting right |

**Public functions**

| Function | Access | Description |
|---|---|---|
| `safeMint(address to, string uri)` | Owner only | Mints the next token to `to` with metadata `uri` and returns the new `tokenId` |
| `ownerOf(uint256 tokenId)` | Anyone, read-only | Returns the current owner, which is the on-chain proof of ownership |
| `tokenURI(uint256 tokenId)` | Anyone, read-only | Returns the token's IPFS metadata link |
| `balanceOf(address owner)` | Anyone, read-only | Returns how many tokens an address holds |
| `totalSupply()` | Anyone, read-only | Returns how many tokens have been minted |
| `transferFrom` / `safeTransferFrom` | Token owner or approved address | Moves a token to another address |
| `approve` / `setApprovalForAll` | Token owner | Lets another address transfer your token(s) |
| `transferOwnership` / `renounceOwnership` | Contract owner | Hands over or gives up the minting right |

**Event:** `NFTMinted(address indexed to, uint256 indexed tokenId, string tokenURI)`
is emitted on every mint.

## Security and privileges

- **Only the owner can mint.** `safeMint` is `onlyOwner`. Without this, anyone
  could mint tokens under the `FortyTwoArt` name and fill the collection with
  spam.
- **The owner cannot touch tokens that have been minted.** The contract has
  no admin burn, no forced transfer and no way to change a token's URI. Once a
  token is minted, only its holder (or an address the holder approved)
  controls it.
- **Transfers use the standard, audited code.** Transfer and approval logic
  comes unchanged from OpenZeppelin, so the only custom code is the minting
  logic.
- **`safeMint` uses `_safeMint`.** If the recipient is a contract, it must
  accept ERC-721 tokens, so tokens cannot get stuck in a contract that can't
  handle them.
- **Token IDs are sequential and can't collide.** `_nextTokenId++` gives
  each token a unique ID, and Solidity 0.8 checks every addition for
  overflow.
- **Renouncing ownership disables minting for good.** If
  `renounceOwnership()` is called, nobody can ever mint again. This can be
  used on purpose to close the collection.

More detail is in [documentation/whitepaper.md](documentation/whitepaper.md).

## Technical choices

### Blockchain: Ethereum Sepolia testnet (chain id `11155111`)

| Option | Pros | Cons |
|---|---|---|
| **Ethereum / Sepolia** (chosen) | Where ERC-721 was defined, best tooling (Remix, OpenZeppelin, Etherscan, Pinata), free testnet ETH | Mainnet gas is expensive (doesn't apply on a testnet) |
| BNB Chain | EVM-compatible (BEP-721 is the same interface as ERC-721), cheap gas | Smaller and more centralized validator set, less tooling |
| Polygon | EVM-compatible, very cheap gas | Adds a second network and a bridge for no real benefit at this scale |
| Solana / Flow | Fast and cheap | Not EVM: different languages (Rust, Cadence), different NFT standards, no Remix |

Sepolia is the reference network for the ERC-721 standard, it costs nothing
to use, and because it runs the EVM, the same contract could be deployed on
BNB Chain or Polygon later with no code changes.

### Language: Solidity `^0.8.20`

| Option | Verdict |
|---|---|
| **Solidity** (chosen) | The standard EVM language, supported directly in Remix, and OpenZeppelin's ERC-721 is a one-line import |
| Vyper | Python-like and security-focused, but a much smaller ecosystem and no equivalent to OpenZeppelin's ERC-721 |
| Rust / Cadence | Only needed for Solana or Flow, which were ruled out above |

### Other choices

- **Standard: ERC-721 rather than ERC-1155.** Each artwork is a unique
  1-of-1 piece, which is what ERC-721 models. ERC-1155 is built for
  collections that mix fungible and semi-fungible tokens.
- **Tooling: Remix IDE + MetaMask.** The contract is compiled and deployed
  in the browser, with no local Hardhat or Foundry setup.
- **Storage: IPFS via Pinata.** Storage is decentralized and addressed by
  content, which meets the requirement to store the image with distributed
  registry technology.

## Repository structure

```
TokenizeArt/
├── README.md               <- this file: overview and choices
├── code/
│   └── FortyTwoNFT.sol     <- the ERC-721 smart contract
├── deployment/
│   └── README.md           <- step-by-step deployment with Remix + MetaMask
├── mint/
│   ├── README.md           <- how to upload to IPFS, mint and prove ownership
│   └── metadata.json       <- example token metadata
└── documentation/
    └── whitepaper.md       <- architecture, permissions and security write-up
```

## Quick start

**You need:** MetaMask on the Sepolia network and some free SepoliaETH from a
faucet.

1. **Read** the contract: [code/FortyTwoNFT.sol](code/FortyTwoNFT.sol).
2. **Deploy** it with Remix by following [deployment/README.md](deployment/README.md).
3. **Mint** a token by following [mint/README.md](mint/README.md): upload the
   image and metadata to IPFS, then call `safeMint`.
4. **Prove ownership**: call `ownerOf(tokenId)` and check that it returns
   your address.
5. **Learn more** in [documentation/whitepaper.md](documentation/whitepaper.md).

## Deployed contract

| | |
|---|---|
| **Network** | Ethereum Sepolia (chain id `11155111`) |
| **Contract address** | _fill in after deploying, see [deployment/README.md](deployment/README.md)_ |
| **Explorer** | `https://sepolia.etherscan.io/address/<address>` |
| **Name / Symbol** | `FortyTwoArt` / `F42` |

## Glossary

- **EVM (Ethereum Virtual Machine):** the runtime that every Ethereum node
  uses to execute smart contracts, so that all nodes agree on the result of
  each transaction. Chains that are "EVM-compatible" (BNB Chain, Polygon) can
  run the same compiled contract.
- **ERC-721:** the Ethereum standard interface for non-fungible tokens.
- **Smart contract:** a program deployed on a blockchain. Once deployed, its
  code can't be changed.
- **IPFS:** the InterPlanetary File System, a peer-to-peer storage network
  where each file is addressed by a hash of its content (a **CID**).
- **Token URI:** the link stored on-chain for each token that points to its
  metadata JSON.
- **Testnet:** a copy of a blockchain used for testing, where the coins have
  no real value.
- **Gas:** the fee paid to run a transaction on the network.
