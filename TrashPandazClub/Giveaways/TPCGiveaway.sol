// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TPCGiveaway {
    using Counters for Counters.Counter;
    Counters.Counter private giveawayIds;
    using SafeERC20 for ERC20;
    address public erc20Token;
    mapping(address => bool) admin;
    mapping(address => bool) public blacklist;
    mapping(address => bool) public whitelist;
    bool public whitelistEnabled;
    uint public creatorFee;
    uint public creatorRoyalty;
    bool public entryFeeEnabled;
    bool public creatorFeeEnabled;

    address[] public participants;

    struct Giveaway{
        address creator;
        uint entryFee;
        string prize;
        uint numberOfWinners;
        uint startTime;
        uint duration;
        address[] participants;
        mapping(address => bool) entered;
        mapping(address => bool) won;
        address[] winners;
        bool ended;
        uint royaltyPool;
    }
    mapping(uint => Giveaway) public giveaways;

    constructor(address _erc20Token){
        erc20Token = _erc20Token;
        admin[msg.sender] = true;
        creatorFee = 1000; // erc20*10**18
        creatorRoyalty = 80; // %
        creatorFeeEnabled = false;
        entryFeeEnabled = false;
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

    modifier whitelisted{
        if(whitelistEnabled){
            require(whitelist[msg.sender]==true,"You are not whitelisted to create giveaways.");
        }
        _;
    }

    // Events ...........................................

    event WinnersPicked(uint giveawayId, address[] winners);
    event GiveawayCreated(uint giveawayId,address creator,uint entryFee, string prize, uint numberOfWinners,uint startTime, uint duration);
    event NewParticipant(uint giveawayaId, address participant);
    event RoyaltyTransferred(uint giveawayaId, address creator, uint royalty);

    // Functions ........................................

    function createGiveaway(uint _entryFee, string memory _prize, uint _numberOfWinners, uint _duration) public blacklisted whitelisted{
        if(creatorFeeEnabled){
            require(ERC20(erc20Token).allowance(msg.sender, address(this)) >= (creatorFee*10**18), "Insufficient allowance");
            require(ERC20(erc20Token).balanceOf(msg.sender) >= (creatorFee*10**18), "You dont have enough tokens to create a giveaway.");
            ERC20(erc20Token).safeTransferFrom(msg.sender, address(this), (creatorFee*10**18));
        }
        giveawayIds.increment();
        uint _giveawayId = giveawayIds.current();
        Giveaway storage newGiveaway = giveaways[_giveawayId] ;
        newGiveaway.creator = msg.sender;
        if(entryFeeEnabled){
            newGiveaway.entryFee = _entryFee;
        }
        newGiveaway.prize = _prize;
        newGiveaway.numberOfWinners = _numberOfWinners;
        newGiveaway.startTime = block.timestamp;
        newGiveaway.duration = _duration;
        emit GiveawayCreated(
            _giveawayId, 
            giveaways[_giveawayId].creator, 
            giveaways[_giveawayId].entryFee,
            giveaways[_giveawayId].prize, 
            giveaways[_giveawayId].numberOfWinners, 
            giveaways[_giveawayId].startTime, 
            giveaways[_giveawayId].duration
        );
    }

    function enterGiveaway(uint _giveawayId) public blacklisted{
        // make sure they have enough tokens to enter
        if(giveaways[_giveawayId].entryFee>0){
            require(ERC20(erc20Token).allowance(msg.sender, address(this)) >= (giveaways[_giveawayId].entryFee*10**18), "Insufficient allowance");
            require(ERC20(erc20Token).balanceOf(msg.sender) >= (giveaways[_giveawayId].entryFee*10**18), "You dont have enough tokens to enter.");
            ERC20(erc20Token).safeTransferFrom(msg.sender, address(this), (giveaways[_giveawayId].entryFee*10**18));
            giveaways[_giveawayId].royaltyPool += (giveaways[_giveawayId].entryFee*10**18);
        }
        require(giveaways[_giveawayId].creator != msg.sender, "You cant enter your own giveaway.");
        require(giveaways[_giveawayId].entered[msg.sender] == false,"You already entered this giveaway.");
        require(giveaways[_giveawayId].startTime+giveaways[_giveawayId].duration >= block.timestamp, "This giveaway has ended. Sorry.");
        require(giveaways[_giveawayId].ended == false, "This giveaway has ended. Sorry.");
        giveaways[_giveawayId].participants.push(msg.sender);
        giveaways[_giveawayId].entered[msg.sender] = true;
        emit NewParticipant(_giveawayId,msg.sender);
    }

    function endGiveaway(uint _giveawayId, uint _seed) public blacklisted whitelisted{
        if(admin[msg.sender]==false){
            require(giveaways[_giveawayId].creator == msg.sender, "Only the giveaway creator can pick winners!");
            require(giveaways[_giveawayId].participants.length > 0, "There were no participants. Sorry.");
            require(giveaways[_giveawayId].startTime + giveaways[_giveawayId].duration <= block.timestamp, "This giveaway is still running.");
        }
        require(giveaways[_giveawayId].ended == false, "This giveaway already ended");

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
        transferRoyalties(_giveawayId);
        giveaways[_giveawayId].ended = true;
    }

    function isIndexUsed(uint256[] memory usedIndexes, uint256 randomIndex) internal pure returns (bool) {
        for (uint256 i = 0; i < usedIndexes.length; i++) {
            if (usedIndexes[i] == randomIndex) {
                return true;
            }
        }
        return false;
    }

    function transferRoyalties(uint _giveawayId) private {
        uint _royalty = giveaways[_giveawayId].royaltyPool * creatorRoyalty / 100;
        if(_royalty > 0){
            ERC20(erc20Token).safeTransferFrom(address(this),giveaways[_giveawayId].creator, _royalty);
            emit RoyaltyTransferred(_giveawayId,giveaways[_giveawayId].creator,(_royalty/10**18));
        }
    }

    // View ........................................................

    function viewTimeUntilEnd(uint _giveawayId) public view returns(uint){
        uint _time = giveaways[_giveawayId].startTime + giveaways[_giveawayId].duration - block.timestamp;
        if(_time>0){
            return _time;
        }else{
            return 0;
        }
    }

    function viewWinners(uint _giveawayId) public view returns(address[] memory){
        address[] memory _winners = new address[](giveaways[_giveawayId].winners.length);
        _winners = giveaways[_giveawayId].winners;
        return _winners;
    }

    function viewParticipants(uint _giveawayId) public view returns(address[] memory){
        address[] memory _participants = new address[](giveaways[_giveawayId].participants.length);
        _participants = giveaways[_giveawayId].participants;
        return _participants;
    }

    // ADMIN ........................................................

    function destroyGiveaway(uint _giveawayId, bool _bool) public adminRole{
        giveaways[_giveawayId].ended = _bool;
    }

    function setCreatorFee(uint _creatorFee) public adminRole{
        creatorFee = _creatorFee;
    }

    function setCreatorRoyalty(uint _creatorRoyalty) public adminRole{
        creatorRoyalty = _creatorRoyalty;
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

    function addAdmin(address _address, bool _bool) public adminRole{
        admin[_address] = _bool;
    }

    function addBlacklist(address[] memory _address, bool _bool) public adminRole{
        for(uint i=0;i<_address.length;i++){
            blacklist[_address[i]] = _bool;
        }
    }

    function addWhitelist(address[] memory _address, bool _bool) public adminRole{
        for(uint i=0;i<_address.length;i++){
            blacklist[_address[i]] = _bool;
        }
    }

    function setWhitelistEnabled(bool _bool) public adminRole{
        whitelistEnabled = _bool;
    }

    function setCreatorFeeEnabled(bool _bool) public adminRole{
        creatorFeeEnabled = _bool;
    }

    function setEntryFeeEnabled(bool _bool) public adminRole{
        entryFeeEnabled = _bool;
    }

}