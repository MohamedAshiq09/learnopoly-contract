// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearnopolyRewards {
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

    event AchievementAdded(
        address indexed user,
        string name,
        string description,
        uint256 timestamp
    );

    event BadgeClaimed(
        address indexed user,
        uint256 badgeId,
        string badgeName,
        uint256 rewardPoints
    );

    uint256 private badgeCounter; 

    constructor() {

        _addBadge("Beginner", "Completed your first course!", 100);
        _addBadge("Networker", "Connected with 10 professionals!", 250);
        _addBadge("Tech Enthusiast", "Participated in a tech quiz!", 500);
    }

    function addAchievement(address _user, string memory _name, string memory _description) public {
        Achievement memory newAchievement = Achievement({
            name: _name,
            description: _description,
            timestamp: block.timestamp
        });
        userAchievements[_user].push(newAchievement);
        emit AchievementAdded(_user, _name, _description, block.timestamp);
    }

    function addRewardPoints(address _user, uint256 _points) public {
        userRewardPoints[_user] += _points;
    }

    function claimBadge(uint256 _badgeId) public {
        Badge memory badge = badges[_badgeId];
        require(userRewardPoints[msg.sender] >= badge.rewardPoints, "Not enough reward points");

        userRewardPoints[msg.sender] -= badge.rewardPoints;
        emit BadgeClaimed(msg.sender, badge.id, badge.name, badge.rewardPoints);
    }

    function getUserAchievements(address _user) public view returns (Achievement[] memory) {
        return userAchievements[_user];
    }

    function _addBadge(string memory _name, string memory _description, uint256 _rewardPoints) internal {
        badges[badgeCounter] = Badge({
            id: badgeCounter,
            name: _name,
            description: _description,
            rewardPoints: _rewardPoints
        });
        badgeCounter++;
    }
}
