// SPDX-License-Identifier: MIT LICENSE
/* MegaMillies Contract by COSMIC ✨ Lord of the TrashPandazClub*/


/// Not sure if there should be a waiting period or if the winning numbers are selected first and then people can try to mint the jackpot as much as they want.
// oooor I can make two versions. One is the Mega Millies. The other is a "scratcher" style lottery where the numbers are picked randomly for each person.


pragma solidity ^0.8.7;

contract TPC_MegaMillies {

    uint private chars = 50;
    string private nonceString = "this is a randomizer";
    uint private nonceNum = 12;
    uint private ticketNumbers = 4;
    uint public redemptionTime = 7;

    // stats
    uint public currentGameID = 0;

    struct Winner{
        address winner;
        uint prize;
    }

    struct Game{
        uint[] winningNumbers;
        Winner[] winners;
        uint prizePool;
        uint prizeClaimed;
        uint ticketsSold;
    }
    mapping(uint=>Game) gameInfo;


    function checkDuplicates(uint _num, uint[] memory _arr) public pure returns (bool) {
        for (uint i = 0; i < _arr.length; i++) {
            if (_arr[i] == _num) {
                return true;
            }
        }
        return false;
    }

    function checkDuplicatesArrayOnly(uint[] memory A) internal pure returns (bool) {
        if (A.length == 0) {
        return false;
        }
        for (uint256 i = 0; i < A.length - 1; i++) {
        for (uint256 j = i + 1; j < A.length; j++) {
            if (A[i] == A[j]) {
            return true;
            }
        }
        }
        return false;
    }

    function randomChoice(uint num) private view returns(uint) {
        uint _randomIndex = uint(keccak256(abi.encodePacked((block.timestamp+num*nonceNum), nonceString, (num*nonceNum), msg.sender))) % chars;
        return _randomIndex;
    }

    function selectWinningNumbers() public view returns(uint[] memory){
        uint[] memory _selection = new uint[](ticketNumbers);
        uint j = 0;
        uint _rand;
        for (uint i; i<ticketNumbers; i++){
            do{
                j+=nonceNum;
                _rand = randomChoice(j*nonceNum+nonceNum);
            }
            while(checkDuplicates(_rand, _selection));
            _selection[i]=_rand;
        }
        return _selection;
    }

    function selectNumbersRandom() private view returns(uint[] memory){
        uint[] memory _selection = new uint[](ticketNumbers);
        uint j = 0;
        uint _rand;
        for (uint i; i<ticketNumbers; i++){
            do{
                j+=nonceNum;
                _rand = randomChoice(j);
            }
            while(checkDuplicates(_rand, _selection));
            _selection[i]=_rand;
        }
        return _selection;
    }

    function mintLottoTicket(uint[] memory _chars) public returns(uint[] memory){
        require(_chars.length==ticketNumbers || _chars.length== 0, "Incorrect number of characters in string.");
        require(!checkDuplicatesArrayOnly(_chars), "You can not use the same number multiple times.");
        uint[] memory _charsSelected;
        if(_chars.length==ticketNumbers){
            _charsSelected = _chars;
        }else{
            _charsSelected = selectNumbersRandom();
        }
        //Mint _charsSelected!
        gameInfo[currentGameID].ticketsSold++;
        return _charsSelected;
    }

    function pickWinningNumbers() public {
        uint[] memory _wn = selectWinningNumbers();
        for(uint i; i<_wn.length; i++){
            gameInfo[currentGameID].winningNumbers.push(_wn[i]);
        }

        // get current balance of matic / trash and push to prizePool
        gameInfo[currentGameID].prizePool = 180; //address(this).balance?
        currentGameID++;
    }

    function redeemLottoTicket(uint _gameID) public {
        // check if user has game ticket
        // check if ticket has been redeemed already
        // if not redeemed and a winner then set ticket to redeemed and update graphics
        // add to list of winners of the Game number
        
        // gameID should be read from the nft. If the numbers match then you can add winner based onthe nft gameid.
        uint _prize = 50;
        Winner memory _winner = Winner(msg.sender,_prize);
        gameInfo[_gameID].winners.push(_winner);
        gameInfo[_gameID].prizeClaimed += _prize;
    }





    // info

    function getGameInfo(uint _gameID) public view returns(Game memory){
        return gameInfo[_gameID];
    }

    function getWinningNumbers(uint _gameID) public view returns(uint[] memory){
        return gameInfo[_gameID].winningNumbers;
    }

    function getTicketsSold(uint _gameID) public view returns(uint){
        return gameInfo[_gameID].ticketsSold;
    }

    function getPrizePool(uint _gameID) public view returns(uint){
        return gameInfo[_gameID].prizePool;
    }

    function getPrizeClaimed(uint _gameID) public view returns(uint){
        return gameInfo[_gameID].prizeClaimed;
    }

    function getWinners(uint _gameID) public view returns(Winner[] memory){
        return gameInfo[_gameID].winners;
    }

    

}