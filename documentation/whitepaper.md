# FortyTwoNFT - Documentation

## What this is

A single ERC-721 smart contract, `FortyTwoNFT` (collection name
`FortyTwoArt`, symbol `F42`), that lets its owner mint unique NFTs. Each NFT has its own metadata (name,
description, image, attributes) hosted on IPFS, referenced via `tokenURI`.

## Actions possible with this NFT

Once a token is minted, here is everything that can be done with it, and
who can do it:

| Action | Who can do it | How |
|---|---|---|
| Mint a new NFT | Contract owner only | Call `safeMint(to, uri)` => see `mint/README.md` |
| Check who owns a token | Anyone (read-only, free) | Call `ownerOf(tokenId)` |
| Check how many tokens an address holds | Anyone (read-only, free) | Call `balanceOf(address)` |
| Read a token's metadata link | Anyone (read-only, free) | Call `tokenURI(tokenId)` |
| Check total tokens minted so far | Anyone (read-only, free) | Call `totalSupply()` |
| Transfer a token to someone else | The token's current owner, or an approved address | Call `transferFrom` / `safeTransferFrom` (inherited from OpenZeppelin's ERC721) |
| Approve someone else to transfer a specific token | The token's current owner | Call `approve(operator, tokenId)` |
| Approve someone else to transfer *all* your tokens | Any token holder | Call `setApprovalForAll(operator, true)` |

Minting is intentionally the only privileged action. Everything else
(checking ownership, reading metadata, transferring) works exactly like
any standard ERC-721 token, with no special permissions beyond normal
token ownership. See `mint/README.md` for the concrete step-by-step of
minting a token via Remix.

## Standard used

ERC-721 - the standard non-fungible token interface. This was
chosen over ERC-1155 (multi-token) because each token here represents a
distinct, one-of-a-kind piece of art, which is exactly what ERC-721 models.

## Architecture

- **`ERC721`** (OpenZeppelin): base standard implementation - transfer,
  approval, `ownerOf`, `balanceOf`, etc.
- **`ERC721URIStorage`** (OpenZeppelin): lets each token id have its own
  metadata URI, rather than one shared URI pattern for the whole collection.
  This matters because every NFT here has a different image/description.
- **`Ownable`** (OpenZeppelin): restricts minting to a single owner address.

## Why minting is owner-restricted

The subject asks that all aspects of security - ownership and privileges
be thought through. Leaving `safeMint` public would let anyone mint tokens
under the `FortyTwoArt` / `F42` collection name, diluting and spamming it.
Restricting it to `onlyOwner` means only the deployer controls what gets
added to the collection. Note this is separate from *token* ownership: once
minted, an NFT is fully owned and transferable by whoever holds it - the
contract owner has no special power over already-minted tokens (no admin
burn, no forced transfer, no royalty siphon).

## Metadata & storage

- **Image**: stored on IPFS (via Pinata), referenced as `ipfs://<CID>`.
- **Metadata JSON**: also stored on IPFS, following the standard schema
  (`name`, `description`, `image`, `attributes`). This is what `tokenURI`
  returns, and what NFT marketplaces/explorers read to render the token.
- IPFS was chosen (over centralized storage) because it's the standard
  distributed storage approach for NFTs and satisfies the subject's
  requirement that the image be stored via distributed registry technology.

## How to verify it works

1. Deploy the contract (see `deployment/README.md`).
2. Mint a token (see `mint/README.md`).
3. Call `ownerOf(tokenId)` - returns the current owner's address, proving
   on-chain ownership.
4. Call `tokenURI(tokenId)` - returns the IPFS metadata link; fetching it
   returns the JSON with the image link.
5. View the contract and its balance/transfers on Sepolia Etherscan.

## Network

Deployed and tested on **Ethereum Sepolia** (chain id 11155111) - no real
funds involved, `SepoliaETH` obtained free from a public Sepolia faucet.
