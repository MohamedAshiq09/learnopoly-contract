// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LearnopolyCertificate is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    mapping(address => mapping(string => bool)) public courseCompletion;

    constructor(address initialOwner) ERC721("LearnopolyCertificate", "LNC") Ownable(initialOwner) {
        _tokenIdCounter = 1; 
    }

    function completeCourse(address user, string memory courseId) external onlyOwner {
        require(!courseCompletion[user][courseId], "Course already completed!");
        courseCompletion[user][courseId] = true;
    }

    // Function to mint an NFT certificate
    function issueCertificate(address user, string memory courseId, string memory tokenURI) external onlyOwner {
        require(courseCompletion[user][courseId], "Course not completed!");
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;

        _safeMint(user, tokenId);
        _setTokenURI(tokenId, tokenURI);

        // Reset course completion for re-certification if needed
        courseCompletion[user][courseId] = false;
    }

    // Function to retrieve the total number of certificates issued
    function totalCertificatesIssued() external view returns (uint256) {
        return _tokenIdCounter - 1; // Subtract 1 as token IDs start from 1
    }
}