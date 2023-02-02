// SPDX-License-Identifier: MIT LICENSE
/* MegaMillies Contract by COSMIC ✨ Lord of the TrashPandazClub*/

pragma solidity ^0.8.7;

contract TPC_MegaMillies {

    string[] private chars = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'];
    string private nonceString = "this is a randomizer";
    uint private nonceNum = 12;
    uint private ticketNumbers = 4;
    uint public redemptionTime = 7;

    // stats
    uint public gameID = 0;

    struct Game{
        string[] winningNumbers;
        address[] winners;
    }
    mapping(uint=>Game) gameInfo;

    // string[][] public winningNumbers;

    function randomChoice(uint num) private view returns(string memory) {
        uint _randomIndex = uint(keccak256(abi.encodePacked((block.timestamp+num*nonceNum), nonceString, (num*nonceNum), msg.sender))) % chars.length;
        return chars[_randomIndex];
    }

    function selectWinningNumbers() public view returns(string[] memory){
        string[] memory _selection = new string[](ticketNumbers);
        for (uint i; i<ticketNumbers; i++){
            _selection[i]=randomChoice(i*nonceNum+nonceNum);
        }
        return _selection;
    }

    function selectNumbersRandom() private view returns(string[] memory){
        string[] memory _selection = new string[](ticketNumbers);
        for (uint i; i<ticketNumbers; i++){
            _selection[i]=randomChoice(i);
        }
        return _selection;
    }

    function mintLottoTicket(string[] memory _chars) public view returns(string[] memory){
        require(_chars.length==ticketNumbers || _chars.length== 0, "Incorrect number of characters in string.");
        string[] memory _charsSelected;
        if(_chars.length==ticketNumbers){
            _charsSelected = _chars;
        }else{
            _charsSelected = selectNumbersRandom();
        }
        //Mint _charsSelected!
        return _charsSelected;
    }

    function pickWinningNumbers() public {
        string[] memory _wn = selectWinningNumbers();
        for(uint i; i<_wn.length; i++){
            gameInfo[gameID].winningNumbers.push(_wn[i]);
        }
        gameID++;
    }

    function redeemLottoTicket(uint _gameID) public {
        // check if user has game ticket
        // check if ticket has been redeemed already
        // if not redeemed and a winner then set ticket to redeemed and update graphics
        // add to list of winners of the Game number
        
        // gameID should be read from the nft. If the numbers match then you can add winner based onthe nft gameid.
        gameInfo[_gameID].winners.push(msg.sender);
    }

    function getWinningNumbers(uint _gameID) public view returns(string[] memory){
        return gameInfo[_gameID].winningNumbers;
    }

    function getGameInfo(uint _gameID) public view returns(Game memory){
        return gameInfo[_gameID];
    }

}