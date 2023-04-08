// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract TPCGiveaway is AccessControl{
    using Counters for Counters.Counter;
    Counters.Counter private giveawayIds;
    using SafeERC20 for ERC20;
    address public erc20Token;

    mapping (address => bool) admin;
    mapping(address => bool) public blacklist;

    uint public giveawayCreatorFee;

    struct Giveaway{
        address creator;
        uint ticketPrice;
        bytes prize;
        uint numberOfWinners;
        uint startTime;
        uint duration;
        address[] participants;
        mapping(address => bool) entered;
        mapping(address => bool) won;
        address[] winners;
        bool destroyed;
    }
    mapping(uint => Giveaway) public giveaways;
    mapping(uint => bool) public giveawayEnded;

    constructor(address _erc20Token, uint _giveawayCreatorFee){
        erc20Token = _erc20Token;
        admin[msg.sender] = true;
        giveawayCreatorFee = _giveawayCreatorFee;
    }

    // Modifiers .........................................

    modifier adminRole{
        require(admin[msg.sender]==true,"Nice Try Guy");
        _;
    }

    modifier blacklisted{
        require(blacklist[msg.sender]==false,"You have been blacklisted. Don't come back here.");
        _;
    }

    // Events ...........................................

    event WinnersPicked(uint giveawayId, address[] winners);
    event GiveawayCreated(uint giveawayId,address creator,uint ticketPrice, bytes prize, uint numberOfWinners,uint startTime, uint duration);
    event NewParticipant();
    // Functions ........................................

    function createGiveaway(uint _ticketPrice, bytes memory _prize, uint _numberOfWinners, uint _duration) public blacklisted{
        giveawayIds.increment();
        uint _giveawayId = giveawayIds.current();
        Giveaway storage newGiveaway = giveaways[_giveawayId] ;
        newGiveaway.creator = msg.sender;
        newGiveaway.ticketPrice = _ticketPrice;
        newGiveaway.prize = _prize;
        newGiveaway.numberOfWinners = _numberOfWinners;
        newGiveaway.startTime = block.timestamp;
        newGiveaway.duration = _duration;
        emit GiveawayCreated(
            _giveawayId, 
            giveaways[_giveawayId].creator, 
            giveaways[_giveawayId].ticketPrice,
            giveaways[_giveawayId].prize, 
            giveaways[_giveawayId].numberOfWinners, 
            giveaways[_giveawayId].startTime, 
            giveaways[_giveawayId].duration
        );
    }

    function enterGiveaway(uint _giveawayId) public {
        // make sure they have enough tokens to enter
        require(ERC20(erc20Token).allowance(msg.sender, address(this)) >= (giveaways[_giveawayId].ticketPrice*10**18), "Insufficient allowance");
        require(ERC20(erc20Token).balanceOf(msg.sender) >= (giveaways[_giveawayId].ticketPrice*10**18), "You dont have enough tokens to enter.");
        require(giveaways[_giveawayId].entered[msg.sender] == false,"You already entered this giveaway.");
        require(giveaways[_giveawayId].startTime+giveaways[_giveawayId].duration >= block.timestamp, "This giveaway is already over.");
        require(giveaways[_giveawayId].destroyed == false, "This giveaway has been destroyed. Sorry.");
        
        giveaways[_giveawayId].participants.push(msg.sender);
        giveaways[_giveawayId].entered[msg.sender] = true;

        ERC20(erc20Token).safeTransferFrom(msg.sender, address(this), (giveaways[_giveawayId].ticketPrice*10**18));
    }

    function pickWinners(uint _giveawayId, uint _seed) public {
        require(giveaways[_giveawayId].creator == msg.sender, "Only the giveaway creator can pick winners!");
        require(giveaways[_giveawayId].participants.length > 0, "There were no participants. Sorry.");
        require(giveaways[_giveawayId].startTime+giveaways[_giveawayId].duration <= block.timestamp, "This giveaway is still running.");

        // In case number of winners allowed exceedsd the participants
        if(giveaways[_giveawayId].numberOfWinners>=giveaways[_giveawayId].participants.length){
            giveaways[_giveawayId].winners = giveaways[_giveawayId].participants;
            emit WinnersPicked(_giveawayId, giveaways[_giveawayId].winners);
        } else{
            address[] memory _winners = new address[](giveaways[_giveawayId].numberOfWinners);
            uint256[] memory _usedIndexes = new uint256[](giveaways[_giveawayId].numberOfWinners);

            for (uint256 i = 0; i < giveaways[_giveawayId].numberOfWinners; i++) {
                uint256 _randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i, _seed))) % giveaways[_giveawayId].participants.length;
                while (isIndexUsed(_usedIndexes, _randomIndex)) {
                    _randomIndex = (_randomIndex + 1) % giveaways[_giveawayId].participants.length;
                }
                _usedIndexes[i] = _randomIndex;
                _winners[i] = giveaways[_giveawayId].participants[_randomIndex];
            }
            giveaways[_giveawayId].winners = _winners;
            emit WinnersPicked(_giveawayId, giveaways[_giveawayId].winners);
        }
        giveawayEnded[_giveawayId] = true;
    }

    function isIndexUsed(uint256[] memory usedIndexes, uint256 randomIndex) internal pure returns (bool) {
        for (uint256 i = 0; i < usedIndexes.length; i++) {
            if (usedIndexes[i] == randomIndex) {
                return true;
            }
        }
        return false;
    }

    // ADMIN

    function destroyGiveaway(uint _giveawayId, bool _bool) public adminRole{
        giveaways[_giveawayId].destroyed = _bool;
    }

    // Set + Remove token
    function setERC20Token(address _erc20Token) public adminRole{
        erc20Token = _erc20Token;
    }
    function removeTokens(address _recipient, uint256 _tokenAmount) public adminRole{
        ERC20(erc20Token).safeTransfer(_recipient, _tokenAmount);
    }
    function removeMatic(address payable _recipient) public adminRole{
        _recipient.transfer(address(this).balance);
    }

    function setAdmin(address _address, bool _bool) public adminRole{
        admin[_address] = _bool;
    }

    function setBlacklist(address _address, bool _bool) public adminRole{
        blacklist[_address] = _bool;
    }

}