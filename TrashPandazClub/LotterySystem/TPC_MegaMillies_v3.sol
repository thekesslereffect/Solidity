// SPDX-License-Identifier: MIT LICENSE
/* MegaMillies Contract by COSMIC ✨ Lord of the TrashPandazClub*/


pragma solidity ^0.8.7;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TPC_MegaMillies is ReentrancyGuard, Ownable, Pausable{

// players select # of ticket numbers (0-9)
// players buy ticket with erc20
// commission fee to help run the lotto
// player bubble sorts numbers and converts to keccak256
// keccak value is stored in an array

// backend
// draw timer is maintained on backend and executed by the backend
// close draw when timer ends
// draw winning numbers based on chainlink vrf
// get the winners of the contract and save it in the lottery id
// open the next lotto

    uint public ticketCost = 4444;
    uint ticketNumbers = 2;
    uint ticketNumberValueMax = 3;
    uint public lotteryID = 0;
    uint public totalTicketSales = 0;
    mapping (uint => bytes32) winningTicketKeccak;
    mapping (uint => uint[]) winningTicket;
    mapping (uint => bytes32[]) ticketEntries;
    mapping (uint => uint) numberOfWinners;
    mapping (address=> mapping(uint=>uint[][])) playerTickets;
    mapping (address=> mapping(uint => bool)) playerTicketsClaimed;
    
    mapping (uint => uint) prizePool;
    uint commission = 1;

    bool public lotteryClosed = false;

    function buyTicketRandom() public returns(uint[] memory){
        require(lotteryClosed==false,"Lottery is closed. Sorry");
        totalTicketSales++;
        uint[] memory _ticket = randomPlayerTicket();
        playerTickets[msg.sender][lotteryID].push(_ticket);
        bytes32 _keccak = toKeccak(_ticket);
        ticketEntries[lotteryID].push(_keccak);
        return _ticket;
    }

    function buyTicket(uint[] memory _numberSelection) public returns(uint[] memory){
        require(lotteryClosed==false,"Lottery is closed. Sorry");
        require(_numberSelection.length == ticketNumbers, "Incorrect amount of numbers selected.");
        totalTicketSales++;
        uint[] memory _ticket = _numberSelection;
        playerTickets[msg.sender][lotteryID].push(_ticket);
        bytes32 _keccak = toKeccak(_ticket);
        ticketEntries[lotteryID].push(_keccak);
        return _ticket;
    }

    function claimPrizes(uint _lotteryID) public {
        require(playerTickets[msg.sender][_lotteryID].length > 0,"You dont have any tickets for that lotteryID");
        require(playerTicketsClaimed[msg.sender][_lotteryID] == false, "Tickets already claimed!");
        uint _winningTickets = 0;
        for(uint i=0; i<playerTickets[msg.sender][_lotteryID].length; i++){
            bytes32 _keccak = toKeccak(playerTickets[msg.sender][_lotteryID][i]);
            if(_keccak==winningTicketKeccak[_lotteryID]){
                _winningTickets++;
            } 
        }
        // transfer winnings * _winningTickets
        playerTicketsClaimed[msg.sender][_lotteryID] = true;
    }




    function openCloseLottery(bool _bool) public onlyOwner returns(bool){
        lotteryClosed = _bool;
        return lotteryClosed;
    }

    function pickWinningTicket(uint _nonce) public returns(uint[] memory){
        uint[] memory _ticket = randomWinningTicket(_nonce);
        winningTicket[lotteryID] = _ticket;
        bytes32 _keccak = toKeccak(_ticket);
        winningTicketKeccak[lotteryID] = _keccak;
        checkNumberOfWinners(_keccak);
        lotteryID++;
        return _ticket;
    }

    function checkNumberOfWinners(bytes32 _keccak) internal returns (uint){
        uint _winners = 0;
        for(uint i=0; i<ticketEntries[lotteryID].length;i++){
            if(ticketEntries[lotteryID][i] == _keccak){
                _winners++;
            }
        }
        numberOfWinners[lotteryID] = _winners;
        return _winners;
    }

    function viewPlayerTickets(address _player, uint _lotteryID) public view returns(uint[][] memory){
        return playerTickets[_player][_lotteryID];
    }

    function viewWinningTicket(uint _lotteryID) public view returns(uint[] memory){
        return winningTicket[_lotteryID];
    }

    function viewNumberOfWinners(uint _lotteryID) public view returns(uint){
        return numberOfWinners[_lotteryID];
    }
    
    function randomPlayerTicket() internal view returns (uint[] memory){
        uint[] memory arr = new uint[](ticketNumbers);
        for(uint i=0; i<arr.length; i++){
            arr[i] = uint(keccak256(abi.encodePacked(block.timestamp,i,msg.sender,totalTicketSales))) % (ticketNumberValueMax + 1) ;
        }
        uint[] memory sortedArr = new uint[](ticketNumbers);
        sortedArr = bubbleSort(arr);
        return sortedArr;
    }

    function randomWinningTicket(uint _nonce) internal view returns (uint[] memory){
        uint[] memory arr = new uint[](ticketNumbers);
        for(uint i=0; i<arr.length; i++){
            arr[i] = uint(keccak256(abi.encodePacked(block.timestamp,i,_nonce,msg.sender,totalTicketSales))) % (ticketNumberValueMax + 1) ;
        }
        uint[] memory sortedArr = new uint[](ticketNumbers);
        sortedArr = bubbleSort(arr);
        return sortedArr;
    }

    function bubbleSort(uint[] memory _nums) internal pure returns(uint[] memory){
        uint[] memory arr = new uint[](_nums.length);
        arr = _nums;
        for(uint i=0; i<arr.length-1;i++){
            for(uint j=0; j<arr.length-1;j++){
                if(arr[j]>arr[j+1]){
                    uint current_val = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = current_val;
                }
            }
        }
        return arr;
    }
    
    function toKeccak(uint[] memory _nums) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(_nums));
    }

}