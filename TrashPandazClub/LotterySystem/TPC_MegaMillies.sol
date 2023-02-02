// SPDX-License-Identifier: MIT LICENSE
/* MegaMillies Contract by COSMIC ✨ Lord of the TrashPandazClub*/

pragma solidity ^0.8.7;

contract MegaMillies {
    string[] private chars = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'];
    string private nonceString = "this is a randomizer";
    uint private nonceNum = 12;
    uint private ticketNumbers = 4;
    uint public gameID = 0;
    uint public redemptionTime = 7;
    
    struct Game {
        uint gameID;
        uint timestamp;
        string[] winningNumbers;
        address[] winners;
        uint pot;
    }

    mapping (uint=>Game) public games;

    function randomChoice(uint num) private view returns(string memory) {
        uint _randomIndex = uint(keccak256(abi.encodePacked((block.timestamp+num*nonceNum), nonceString, (num*nonceNum), msg.sender))) % chars.length;
        return chars[_randomIndex];
    }

    function selectWinningNumbers() private view returns(string[] memory){
        string[] memory _selection = new string[](ticketNumbers);
        for (uint i; i<ticketNumbers; i++){
            _selection[i]=randomChoice(i*nonceNum+nonceNum);
        }
        return _selection;
    }

    function selectNumbers() private view returns(string[] memory){
        string[] memory _selection = new string[](ticketNumbers);
        for (uint i; i<ticketNumbers; i++){
            _selection[i]=randomChoice(i);
        }
        return _selection;
    }

    function mintLottoTicket() public view returns(string[] memory){
        return selectNumbers();
    }

    function pickWinners() public returns(Game memory){
        string[] memory _winningNumbers = selectWinningNumbers();
        games[gameID].gameID = gameID;
        games[gameID].timestamp = block.timestamp;
        games[gameID].winningNumbers = _winningNumbers;
        games[gameID].pot = 50;
        gameID++;
        return games[gameID];
    }

    function redeemLottoTicket() public view{
        // check if user has game ticket
        // check if ticket has been redeemed already
        // if not redeemed and a winner then set ticket to redeemed and update graphics
        // add to list of winners of the Game number

    }

}