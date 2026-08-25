# Minting

## 1. Create your image

- Make an image that clearly includes the number **42** (legible, not
  distorted — see subject warning about badly-displayed "42"s).
- No offensive content.

## 2. Upload image + metadata to IPFS

Easiest route: [Pinata](https://app.pinata.cloud) (free tier is enough).

1. Upload your image file. Pinata gives you a CID, e.g. `bafybe...xyz`.
2. Edit `mint/metadata.json`:
   - Set `"image"` to `ipfs://<image_CID>/<filename>`.
   - Set the `Artist` attribute to **your 42 login** (required by the
     subject) and give it a real title in `"name"`.
3. Upload `metadata.json` itself to Pinata too. This gives you a second CID
   — this is your **token URI**, e.g. `ipfs://<metadata_CID>`.

## 3. Mint through Remix

1. With the contract already deployed (see `deployment/README.md`), go back
   to Remix's "Deploy & Run Transactions" tab.
2. Under "Deployed Contracts", expand your `FortyTwoNFT` instance.
3. Find the `safeMint` function. Fill in:
   - `to`: the wallet address that should own the NFT (your own address is
     fine for the demo).
   - `uri`: the `ipfs://<metadata_CID>` from step 2.
4. Click **transact**, confirm in MetaMask.
5. Once mined, expand the transaction logs in Remix's terminal — you'll see
   the `NFTMinted` event with the new `tokenId` (starts at `0`).

## 4. Prove ownership

In Remix, call the read-only `ownerOf` function with the `tokenId` you just
minted. It should return the `to` address you minted to — this is the
on-chain proof of ownership the subject asks for.

You can also call `tokenURI(tokenId)` to confirm it returns your IPFS
metadata link, and view the NFT itself on
`https://sepolia.etherscan.io/address/<contract_address>` (Etherscan
resolves ERC-721 token metadata automatically — check the "Tokens" or
"NFT Transfers" tab under your contract's address).

## Record here after minting

- **Token ID:** 
- **Owner address:** 
- **Token URI:** `ipfs://...`
- **Transaction hash:** 
