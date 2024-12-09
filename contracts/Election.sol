// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./VotersRegistration.sol";

contract Election {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint256 voteWeight;
        address delegate;
    }

    address public owner;

    VoterRegistration public voterRegistration;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;

    bool public electionClosed;

    string public stateName;

    constructor(address _voterRegistrationAddress, string memory _stateName) {
        owner = msg.sender;
        voterRegistration = VoterRegistration(_voterRegistrationAddress);
        stateName = _stateName;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier electionOpen() {
        require(!electionClosed, "Election is closed");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(voterRegistration.isVoterRegistered(msg.sender), "Only registered voters can perform this action");
        _;
    }



    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    function delegateVote(address _to) public electionOpen onlyRegisteredVoter {
        require(_to != msg.sender, "Self delegation is not allowed");
        require(!voters[msg.sender].hasVoted, "You have already voted");


        voters[msg.sender].delegate = _to;
        voters[_to].voteWeight += 1;
    }

    function vote(uint256 _candidateIndex) public electionOpen onlyRegisteredVoter {
        require(!voters[msg.sender].hasVoted, "Already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        voters[msg.sender].hasVoted = true;
        uint256 voteWeight = voters[msg.sender].voteWeight > 0
            ? voters[msg.sender].voteWeight
            : 1;
        candidates[_candidateIndex].voteCount += voteWeight;
    }

    function endElection() public onlyOwner {
        electionClosed = true;
    }

    function getWinner() public view returns (string memory) {
        require(electionClosed, "Election is not closed yet");
        uint256 winningVoteCount = 0;
        uint256 winningCandidateIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateIndex = i;
            }
        }

        return candidates[winningCandidateIndex].name;
    }
}