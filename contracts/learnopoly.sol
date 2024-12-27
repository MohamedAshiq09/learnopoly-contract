// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Learnopoly is ERC721URIStorage, Ownable {
    uint256 public nextTokenId = 1;

    struct Achievement {
        string name;
        string description;
        uint256 timestamp;
    }

    struct Badge {
        uint256 id;
        string name;
        string description;
        uint256 rewardPoints;
    }

    mapping(address => Achievement[]) public userAchievements;
    mapping(address => uint256) public userRewardPoints;
    mapping(uint256 => Badge) public badges;

    event AchievementAdded(address indexed user, string name, uint256 timestamp);
    event BadgeClaimed(address indexed user, uint256 badgeId);
    event CertificateMinted(address indexed user, uint256 tokenId, string uri);

    
    constructor() ERC721("LearnopolyCertificate", "LPCERT") Ownable(msg.sender) {}

    function _addBadge(
        uint256 id,
        string memory name,
        string memory description,
        uint256 rewardPoints
    ) internal {
        badges[id] = Badge(id, name, description, rewardPoints);
    }

    function addAchievement(address user, string memory name, string memory description) public onlyOwner {
        userAchievements[user].push(Achievement(name, description, block.timestamp));
        emit AchievementAdded(user, name, block.timestamp);
    }

    function addRewardPoints(address user, uint256 points) public onlyOwner {
        userRewardPoints[user] += points;
    }

    function claimBadge(uint256 badgeId) public {
        Badge memory badge = badges[badgeId];
        require(badge.id != 0, "Badge does not exist");
        require(userRewardPoints[msg.sender] >= badge.rewardPoints, "Not enough reward points");

        userRewardPoints[msg.sender] -= badge.rewardPoints;
        emit BadgeClaimed(msg.sender, badgeId);
    }

    function mintCertificate(
        address user,
        string memory courseName,
        string memory certificateURI
    ) public onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(user, tokenId);
        _setTokenURI(tokenId, certificateURI);

        string memory achievementDescription = string(
            abi.encodePacked("Certificate for completing the course: ", courseName)
        );
        addAchievement(user, "Course Completion", achievementDescription);

        emit CertificateMinted(user, tokenId, certificateURI);
        nextTokenId++;
    }

    function getUserAchievements(address user) public view returns (Achievement[] memory) {
        return userAchievements[user];
    }

    function initializeBadges() public onlyOwner {
        _addBadge(1, "Beginner", "Completed your first course!", 100);
        _addBadge(2, "Tech Enthusiast", "Earned 500 reward points!", 500);
    }
}
