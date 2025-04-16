// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OracleBounty {
    struct Feed {
        string description;
        string latestValue;
        uint256 lastUpdated;
        uint256 bounty;
    }

    mapping(bytes32 => Feed) public feeds;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function createFeed(string memory _id, string memory _description, uint256 _bounty) external onlyOwner {
        bytes32 feedKey = keccak256(abi.encodePacked(_id));
        feeds[feedKey] = Feed(_description, "", 0, _bounty);
    }

    function updateFeed(string memory _id, string memory _newValue) external {
        bytes32 feedKey = keccak256(abi.encodePacked(_id));
        Feed storage feed = feeds[feedKey];
        require(block.timestamp - feed.lastUpdated > 60, "Too soon");

        feed.latestValue = _newValue;
        feed.lastUpdated = block.timestamp;

        payable(msg.sender).transfer(feed.bounty);
    }

    function fundFeed(string memory _id) external payable onlyOwner {
        bytes32 feedKey = keccak256(abi.encodePacked(_id));
        feeds[feedKey].bounty += msg.value;
    }

    receive() external payable {}
}
