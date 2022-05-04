// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Election {
    address owner;
    constructor(){
        owner = msg.sender;
    }
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    event votedEvent (
        uint indexed _candidateId
    );
    function election(string memory _name) public {
        require(owner == msg.sender,"Cant add candidate");
        _addCandidate(_name);
    }
    function _addCandidate (string memory _name) private {
        Candidate memory cand =  Candidate(candidatesCount,_name, 0);
        candidates[candidatesCount] = cand;
        candidatesCount+= 1;
    }
    function vote (uint _candidateId) public {
        require(voters[msg.sender]== false, "HAHA GET LOST");
        require(_candidateId<candidatesCount, "DUDE,GET SOBER!!");
        voters[msg.sender] = true;
        candidates[_candidateId].voteCount+=1;
        emit votedEvent(_candidateId);
    }

    function forFrontEnd() public view returns(Candidate [] memory){
        require(candidatesCount>0, "GIVE ENTRY JETT");
        Candidate[] memory takeitDude = new Candidate[](candidatesCount);
        for(uint i= 0; i< candidatesCount; i++){
            Candidate storage cand = candidates[i];
            takeitDude[i] = cand;
        }
        return takeitDude;
    }
}