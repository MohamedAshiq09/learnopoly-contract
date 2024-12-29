// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract LearnopolyCertificate is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter; 

    event CertificateIssued(address indexed recipient, uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("LearnopolyCertificate", "LNC") Ownable(msg.sender) {}

    function mintCertificate(address recipient, string memory tokenURI) public onlyOwner {
        require(recipient != address(0), "Invalid recipient address");

        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        _mint(recipient, newTokenId);

        _setTokenURI(newTokenId, tokenURI);

        emit CertificateIssued(recipient, newTokenId, tokenURI);
    }

    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIdCounter;
    }
}
