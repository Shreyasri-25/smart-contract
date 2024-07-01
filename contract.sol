pragma solidity ^0.8.0;

contract Voting {
  mapping(address => uint256) public votes;

  function castVote(address candidate) public payable {
    // Check if user already voted
    if (votes[msg.sender] > 0) {
      revert("You have already voted.");
    }

    // Check voting fee if applicable
    if (msg.value > 0) {
      if (msg.value < minimumVoteFee) {
        revert("Insufficient voting fee.");
      }
    }

    // Update vote count for candidate
    votes[candidate] += 1;

    // Assert replaced with require for better error handling
    require(votes[msg.sender] == 1, "Unexpected voting error.");
  }

  function getVotes(address candidate) public view returns (uint256) {
    return votes[candidate];
  }

  uint256 public minimumVoteFee = 0; // No fee by default

  function setMinimumVoteFee(uint256 newFee) public onlyOwner {
    // Check for negative fee
    if (newFee < 0) {
      revert("Minimum voting fee cannot be negative.");
    }

    minimumVoteFee = newFee;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can perform this action.");
    _;
  }

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }
}
