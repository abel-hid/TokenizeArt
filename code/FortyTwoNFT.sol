// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Remix resolves these GitHub-style imports automatically (no npm install needed).
// Deployed on Ethereum Sepolia testnet, so this follows the ERC-721 standard.
import "@openzeppelin/contracts@5.0.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

/// @title FortyTwoNFT
/// @notice A minimal, secure ERC-721 NFT contract for the 1337/42
///         TokenizeArt project. Each token carries its own metadata URI
///         (pointing to IPFS), so every mint can have a unique image + JSON.
/// @dev Security choices, explained in documentation/whitepaper.md:
///      - Only the contract owner can mint (prevents anyone from spamming
///        tokens under this collection's name).
///      - Ownership of the collection itself can be transferred or renounced
///        via Ownable, but token ownership (who holds NFT #N) is fully
///        standard ERC-721 and freely transferable by the token holder.
///      - `ownerOf(tokenId)` (inherited from ERC721) is the canonical way
///        to prove who owns a given NFT, as required by the subject.
contract FortyTwoNFT is ERC721, ERC721URIStorage, Ownable {
    /// @dev Auto-incrementing token id counter. Starts at 0 -> first minted
    ///      token is #0.
    uint256 private _nextTokenId;

    /// @notice Emitted every time a new NFT is minted.
    event NFTMinted(address indexed to, uint256 indexed tokenId, string tokenURI);

    /// @param initialOwner The address that will own (and be allowed to mint
    ///        from) this contract. Pass your own wallet address on deploy.
    constructor(address initialOwner)
        ERC721("FortyTwoArt", "F42")
        Ownable(initialOwner)
    {}

    /// @notice Mint a new NFT to `to`, with metadata at `uri` (expected to be
    ///         an ipfs:// URI pointing at a JSON file following the OpenSea
    ///         metadata standard - see mint/metadata.json for an example).
    /// @dev Restricted to the contract owner, so this collection can't be
    ///      minted into by arbitrary addresses. Returns the new token id so
    ///      it's easy to read back from Remix's console.
    function safeMint(address to, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit NFTMinted(to, tokenId, uri);
        return tokenId;
    }

    /// @notice How many NFTs have been minted from this contract so far.
    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }

    // ---- The two overrides below are required by Solidity whenever a
    // contract inherits from both ERC721 and ERC721URIStorage, since both
    // parent contracts define these functions. This is boilerplate, not
    // custom logic. ----

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
