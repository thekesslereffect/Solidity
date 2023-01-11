pragma solidity ^0.6.0;

contract Lottery {
  // define data structure to store participants and their selected numbers
  struct Participant {
    address addr;
    uint8[] numbers;
  }
  mapping (address => Participant) public participants;

  // function to allow users to enter the lottery
  function enter(uint8[] memory _numbers) public payable {
    // add user's address and selected numbers to participants data structure
    participants[msg.sender] = Participant(msg.sender, _numbers);
  }

  // function to select winning numbers and distribute ether to winners
  function selectWinners() public {
    // ensure only contract owner can access this function
    require(msg.sender == owner);
    // define list of winners and their ether contributions
    mapping (address => uint256) winners;
    // randomly select 4 winning numbers
    uint8[] memory winningNumbers = [random(), random(), random(), random()];
    // iterate through participants to determine winners
    for (uint256 i = 0; i < participants.length; i++) {
      // retrieve participant's selected numbers
      uint8[] memory participantNumbers = participants[i].numbers;
      // compare selected numbers to winning numbers
      bool match = true;
      for (uint8 j = 0; j < winningNumbers.length; j++) {
        if (winningNumbers[j] != participantNumbers[j]) {
          match = false;
          break;
        }
      }
      // if selected numbers match winning numbers, add participant to winners list
      if (match) {
        winners[participants[i].addr] = participants[i].addr.balance;
      }
    }
    // distribute collected ether among winners
    uint256 totalEther = address(this).balance;
    for (uint256 i = 0; i < winners.length; i++) {
      winners[i].transfer(totalEther * winners[i].balance / address(this).balance);
    }
  }

  // function to allow contract owner to withdraw collected ether
  function withdraw() public {
    // ensure only contract owner can access this function
    require(msg.sender == owner);