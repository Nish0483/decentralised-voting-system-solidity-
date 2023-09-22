// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract votingSystem{
    
    enum status{
        running,
        over
    }

    status public currentStatus;
    uint256 public votingStartTime;
    uint256 public votingEndTime;
    address public owner;

    struct candidate{
        uint number;
        string name;
        uint numOfVotes;
    }
   
    candidate[] public candidates;
    mapping (address=>bool)public isVoted;


constructor(){
        owner=msg.sender;
        currentStatus = status.running;
        votingStartTime = block.timestamp; // Record the start time
        votingEndTime = votingStartTime + 24 hours; // Set the end time to 24 hours from the start
    }

 modifier onlyOwner(){
     require(msg.sender==owner,"only owner can make this transctons");
     _;
 }
 modifier votingOpen() {
        require(currentStatus == status.running, "Voting is not open.");
        require(block.timestamp <= votingEndTime, "Voting has ended.");
        _;
    }

 function addUser(string memory _name)  public onlyOwner votingOpen {
     candidates.push(candidate(
         
         {number:candidates.length +1,
         name:_name,
         numOfVotes:0 }
         ));

     
 }  
 
 /* alternative way to add user to struct with .pointer*/

//  function addUser(string memory _name)  public onlyOwner() {
//     candidate memory newCandidate;
//     newCandidate.name=_name;
//     newCandidate.number=candidates.length+1;
//     newCandidate.numOfVotes=0;
//     candidates.push(newCandidate);
//     currentStatus=status.running;

     
// }  




 function viwVotesStatus()public view  returns(string[] memory, uint[] memory) {
       
        string[] memory candidateNames = new string[](candidates.length);
        uint[] memory candidateVotes = new uint[](candidates.length);

        for (uint i = 0; i < candidates.length; i++) {
            candidateNames[i] = candidates[i].name;
            candidateVotes[i] = candidates[i].numOfVotes;
        }

        return (candidateNames, candidateVotes);
    
  
  }
  
  
    
 
function vote(uint num) public votingOpen {

//require  adress is not alreadyvoted
require(!isVoted[msg.sender],"already voted");
require(num>0 && num<candidates.length,"wrong index");// checking input
require(msg.sender!=owner,"owner cant vote");
candidates[num].numOfVotes++;
isVoted[msg.sender]=true;


  
}
function forceStop() public onlyOwner{
    currentStatus=status.over;
}
function resume() public onlyOwner{
    currentStatus=status.running;
}

function resetElection() private onlyOwner{
    currentStatus=status.running;
    delete candidates;
    votingStartTime=block.timestamp;
    votingEndTime=block.timestamp+24 hours;
}

}



