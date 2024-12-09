// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./Election.sol";

contract ElectionFactory {
    struct DeployedElection {
        string stateName;
        address electionAddress;
    }

    DeployedElection[] public deployedElections;
    address public voterRegistrationAddress;

    constructor(address _voterRegistrationAddress) {
        voterRegistrationAddress = _voterRegistrationAddress;
    }

    function deployElection(string memory _stateName) public {
        Election newElection = new Election(voterRegistrationAddress, _stateName);
        deployedElections.push(DeployedElection(_stateName, address(newElection)));
    }

    function addCandidatesToElection(address _electionAddress, string[] memory _candidates) public {
        Election election = Election(_electionAddress);
        for (uint256 i = 0; i < _candidates.length; i++) {
            election.addCandidate(_candidates[i]);
        }
    }

    function getAllElections() public view returns (DeployedElection[] memory) {
        return deployedElections;
    }
}
