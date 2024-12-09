// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract VoterRegistration {
    address public electoralBoard;

    struct Voter {
        address voterAddress;
        bool isRegistered;
        string state;
    }

    mapping(address => Voter) public voters;

    constructor() {
        electoralBoard = msg.sender;
    }

    modifier onlyElectoralBoard() {
        require(
            msg.sender == electoralBoard,
            "Only electoral board can perform this action"
        );
        _;
    }

    function registerVoter(
        address _voter,
        string memory _state
    ) public onlyElectoralBoard {
        require(!voters[_voter].isRegistered, "Voter already registered");
        voters[_voter] = Voter({
            voterAddress: _voter,
            isRegistered: true,
            state: _state
        });
    }

    function isVoterRegistered(address _voter) public view returns (bool) {
        return voters[_voter].isRegistered;
    }

    function getVoterState(address _voter) public view returns (string memory) {
        require(voters[_voter].isRegistered, "Voter not registered");
        return voters[_voter].state;
    }
}