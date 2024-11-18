// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FiddlingNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;

    constructor() ERC721("Fiddle", "FIDDL") {
        s_tokenCounter = 0; // everytime a mint happens, token counter is updated
    }

    function mintNFT(string memory tokenUri) public {
        s_tokenIdToURI[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToURI[tokenId];
    }
}
