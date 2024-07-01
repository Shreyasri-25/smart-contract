pragma solidity ^0.8.0;

contract Voting {
    mapping(address => uint256) public votes;

    function castVote(address candidate) public payable {
        require(votes[msg.sender] == 0, "You have already voted.");

        if (msg.value > 0) {
            require(msg.value >= minimumVoteFee, "Insufficient voting fee.");
        }

        votes[candidate] += 1;
        assert(votes[msg.sender] == 1); // Sender can only have 1 vote
    }

    function getVotes(address candidate) public view returns (uint256) {
        return votes[candidate];
    }
    uint256 public minimumVoteFee = 0; // No fee by default

    function setMinimumVoteFee(uint256 newFee) public onlyOwner {
        require(msg.sender == owner, "Only owner can set minimum voting fee.");

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
