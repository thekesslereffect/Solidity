// SPDX-License-Identifier: MIT LICENSE
/* MegaMillies Contract by COSMIC ✨ Lord of the TrashPandazClub*/


/// Not sure if there should be a waiting period or if the winning numbers are selected first and then people can try to mint the jackpot as much as they want.
// oooor I can make two versions. One is the Mega Millies. The other is a "scratcher" style lottery where the numbers are picked randomly for each person.


pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TPC_MegaMillies {

    address[] public admins;
    mapping(address=>bool) public isAdmin;

    uint private chars = 50;
    string private nonceString = "this is a randomizer";
    uint private nonceNum = 12;
    uint private ticketNumbers = 4;
    uint public redemptionTime = 7;

    // stats
    uint public currentGameID = 0;


    function checkDuplicates(uint _num, uint[] memory _arr) private pure returns (bool) {
        for (uint i = 0; i < _arr.length; i++) {
            if (_arr[i] == _num) {
                return true;
            }
        }
        return false;
    }

    function checkDuplicatesArrayOnly(uint[] memory A) private pure returns (bool) {
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

    function checkNumberTooBig(uint[] memory _chars) private view returns(bool){
        for(uint i; i<_chars.length;i++){
            if(_chars[i]>=chars){
                return true;
            }
        }
        return false;
    }

    function randomChoice(uint num) private view returns(uint) {
        uint _randomIndex = uint(keccak256(abi.encodePacked((block.timestamp+num*nonceNum), nonceString, (num*nonceNum), msg.sender))) % chars;
        return _randomIndex;
    }

    function selectWinningNumbers() private view onlyAdmin returns(uint[] memory){
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

    function mintLottoTicket() private internal {
        // 
    }

    function playLotto() public denyContract nonReentrant returns(uint[] memory){
        uint[] memory _charsSelected;
        _charsSelected = selectNumbersRandom();
        //Mint _charsSelected!
        gameInfo[currentGameID].ticketsSold++;
        // change nonce to random number based on minter address + stuff so you can never figure out the nonce until the person before you mints
        return _charsSelected;
    }

    function redeemLottoTicket(uint _gameID) public denyContract nonReentrant {
    }

    // info

    // Admin Utilities

    function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
        require(_tokenAddress != address(trashToken), "Cannot be TRASH token");
        IERC20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
        emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
    }

    // Security Modifiers

    modifier onlyAdmin {
        require(isAdmin[msg.sender], "Sender is not an admin.");
        _;
    }

    function addAdmin(address _admin) public onlyOwner {
        require(!isAdmin[_admin], "Address is already an admin.");
        isAdmin[_admin] = true;
        admins.push(_admin);
    }

    function removeAdmin(address _admin) public onlyOwner {
        require(isAdmin[_admin], "Address is not an admin.");
        uint index = 0;
        for (uint i = 0; i < admins.length; i++) {
            if (admins[i] == _admin) {
                index = i;
                break;
            }
        }
        isAdmin[_admin] = false;
        delete admins[index];
    }

    // make sure no one can create a smart contract / proxy to interact with functions. Real user wallets only!
    modifier denyContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    function _isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }


}