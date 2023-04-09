// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TPCGiveaway {
    using Counters for Counters.Counter;
    Counters.Counter private giveawayIds;
    using SafeERC20 for IERC20;
    IERC20 public erc20Token;
    mapping(address => bool) admin;
    mapping(address => bool) public blacklist;
    mapping(address => bool) public whitelist;
    bool public whitelistEnabled;
    uint public creatorFee;
    uint public creatorRoyaltyPercent;
    bool public entryFeeEnabled;
    bool public creatorFeeEnabled;
    mapping(address=>uint) public creatorRoyalties;

    struct Giveaway {
        address creator;
        uint entryFee;
        string prize;
        uint numberOfWinners;
        uint startTime;
        uint duration;
        address[] participants;
        mapping(address => uint) enteredIndex;
        address[] winners;
    }
    mapping(uint => Giveaway) public giveaways;

    constructor(IERC20 _erc20Token){
        erc20Token = _erc20Token;
        admin[msg.sender] = true;
        creatorFee = 1000; // erc20*10**18
        creatorRoyaltyPercent = 80; // %
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

    modifier onlyCreator(uint _giveawayId){
        require(giveaways[_giveawayId].creator == msg.sender, "Only the giveaway creator can call this function.");
        _;
    }

    // Events ...........................................

    event WinnersPicked(uint giveawayId, address[] winners);
    event GiveawayCreated(uint giveawayId,address creator,uint entryFee, string prize, uint numberOfWinners,uint startTime, uint duration);
    event NewParticipant(uint giveawayaId, address participant);
    event RoyaltyWithdrawn(address indexed creator, uint256 amount);
    event GiveawayDestroyed(uint giveawayId);

    // Functions ........................................

    // Creates a new giveaway with the provided parameters and stores it in the giveaways mapping
    // Deducts the creator fee from the creator's royalties if they have enough, otherwise transfers it from the creator's balance
    // Emits a GiveawayCreated event
    function createGiveaway(uint _entryFee, string memory _prize, uint _numberOfWinners, uint _duration) public blacklisted whitelisted {
        if(creatorFeeEnabled) {
            uint feeToPay = creatorFee * 10**18;
            uint royalties = creatorRoyalties[msg.sender];
            if (royalties >= feeToPay) {
                royalties -= feeToPay;
                creatorRoyalties[msg.sender] = royalties;
            }else{
                require(
                    IERC20(erc20Token).allowance(msg.sender, address(this)) >= feeToPay &&
                    IERC20(erc20Token).balanceOf(msg.sender) >= feeToPay,
                    "Insufficient balance or allowance to enter."
                );
                IERC20(erc20Token).safeTransferFrom(msg.sender, address(this), feeToPay);
            }
        }
        giveawayIds.increment();
        uint _giveawayId = giveawayIds.current();
        Giveaway storage newGiveaway = giveaways[_giveawayId];
        newGiveaway.creator = msg.sender;
        if(entryFeeEnabled) {
            newGiveaway.entryFee = _entryFee;
        }
        newGiveaway.prize = _prize;
        newGiveaway.numberOfWinners = _numberOfWinners;
        newGiveaway.startTime = block.timestamp;
        newGiveaway.duration = _duration;
        emit GiveawayCreated(
            _giveawayId, 
            newGiveaway.creator, 
            newGiveaway.entryFee,
            newGiveaway.prize, 
            newGiveaway.numberOfWinners, 
            newGiveaway.startTime, 
            newGiveaway.duration
        );
    }

    // Allows a user to enter a giveaway by providing its ID
    // Transfers the required entry fee from the participant's balance and updates the creator's royalties
    // Emits a NewParticipant event
    function enterGiveaway(uint _giveawayId) public blacklisted{
        require(giveaways[_giveawayId].creator != msg.sender, "You cant enter your own giveaway.");
        require(giveaways[_giveawayId].enteredIndex[msg.sender] == 0, "You already entered this giveaway.");
        require(giveaways[_giveawayId].startTime+giveaways[_giveawayId].duration >= block.timestamp, "This giveaway has ended. Sorry.");
        require(giveaways[_giveawayId].winners.length == 0, "This giveaway has ended. Sorry.");
        if(giveaways[_giveawayId].entryFee>0){
            require(
                IERC20(erc20Token).allowance(msg.sender, address(this)) >= giveaways[_giveawayId].entryFee*10**18 &&
                IERC20(erc20Token).balanceOf(msg.sender) >= giveaways[_giveawayId].entryFee*10**18,
                "Insufficient balance or allowance to enter."
            );
            IERC20(erc20Token).safeTransferFrom(msg.sender, address(this), giveaways[_giveawayId].entryFee*10**18);
            creatorRoyalties[giveaways[_giveawayId].creator] += giveaways[_giveawayId].entryFee *10**18 * creatorRoyaltyPercent / 100;
        }
        giveaways[_giveawayId].enteredIndex[msg.sender] = giveaways[_giveawayId].participants.length;
        giveaways[_giveawayId].participants.push(msg.sender);
        emit NewParticipant(_giveawayId,msg.sender);
    }

    // Ends a giveaway by picking winners and updating the winners array in the giveaway struct
    // Emits a WinnersPicked event
    function endGiveaway(uint _giveawayId, uint _seed) public blacklisted whitelisted onlyCreator(_giveawayId){
        require(giveaways[_giveawayId].startTime + giveaways[_giveawayId].duration <= block.timestamp, "This giveaway is still running.");
        require(giveaways[_giveawayId].participants.length > 0, "There were no participants. Sorry.");
        require(giveaways[_giveawayId].winners.length == 0, "This giveaway has ended. Sorry.");
        if(giveaways[_giveawayId].numberOfWinners>=giveaways[_giveawayId].participants.length){
            giveaways[_giveawayId].winners = giveaways[_giveawayId].participants;
            emit WinnersPicked(_giveawayId, giveaways[_giveawayId].winners);
        } else{
            address[] memory _winners = new address[](giveaways[_giveawayId].numberOfWinners);
            uint[] memory _usedIndexes = new uint[](giveaways[_giveawayId].numberOfWinners);
            for (uint i = 0; i < giveaways[_giveawayId].numberOfWinners; i++) {
                uint _randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, i, _seed))) % giveaways[_giveawayId].participants.length;
                while (indexIsUsed(_usedIndexes, _randomIndex)) {
                    _randomIndex = (_randomIndex + 1) % giveaways[_giveawayId].participants.length;
                }
                _usedIndexes[i] = _randomIndex;
                _winners[i] = giveaways[_giveawayId].participants[_randomIndex];
            }
            giveaways[_giveawayId].winners = _winners;
            emit WinnersPicked(_giveawayId, _winners);
        }
    }

    // Checks if a given index is present in the usedIndexes array
    function indexIsUsed(uint[] memory usedIndexes, uint randomIndex) internal pure returns (bool) {
        for (uint i = 0; i < usedIndexes.length; i++) {
            if (usedIndexes[i] == randomIndex) {
                return true;
            }
        }
        return false;
    }

    // Allows a creator to withdraw their earned royalties
    // Emits a RoyaltyWithdrawn event
    function withdrawRoyalties() public {
        uint royalties = creatorRoyalties[msg.sender];
        require(royalties > 0, "No royalties to withdraw.");
        IERC20(erc20Token).safeTransfer(msg.sender, royalties);
        creatorRoyalties[msg.sender] = 0;
        emit RoyaltyWithdrawn(msg.sender, royalties);
    }

    // View ........................................................

    // Returns the time remaining for a giveaway to end
    function viewTimeUntilEnd(uint _giveawayId) public view returns(uint){
        uint _time = giveaways[_giveawayId].startTime + giveaways[_giveawayId].duration - block.timestamp;
        if(_time>0){
            return _time;
        }else{
            return 0;
        }
    }

    // Returns the winners of a giveaway
    function viewWinners(uint _giveawayId) public view returns(address[] memory){
        address[] memory _winners = new address[](giveaways[_giveawayId].winners.length);
        _winners = giveaways[_giveawayId].winners;
        return _winners;
    }

    // Returns the participants of a giveaway
    function viewParticipants(uint _giveawayId) public view returns(address[] memory){
        address[] memory _participants = new address[](giveaways[_giveawayId].participants.length);
        _participants = giveaways[_giveawayId].participants;
        return _participants;
    }

    // Returns the number of participants in a giveaway
    function viewNumberOfParticipants(uint _giveawayId) public view returns(uint){
        uint _participants = giveaways[_giveawayId].participants.length;
        return _participants;
    }

    // ADMIN ........................................................

    // Allows an admin to destroy a giveaway by setting its duration to 0 and winners to an empty array
    // Emits a GiveawayDestroyed event
    function destroyGiveaways(uint[] memory _giveawayId) public adminRole{
        for(uint i=0;i<_giveawayId.length;i++){
            giveaways[_giveawayId[i]].duration = 0;
            address[] memory emptyWinners;
            giveaways[_giveawayId[i]].winners = emptyWinners;
            emit GiveawayDestroyed(_giveawayId[i]);
        }
    }

    // Allows an admin to update the creator fee
    function setCreatorFee(uint _creatorFee) public adminRole{
        creatorFee = _creatorFee;
    }

    // Allows an admin to update the creator royalty percentage
    function setCreatorRoyaltyPercent(uint _creatorRoyaltyPercent) public adminRole{
        creatorRoyaltyPercent = _creatorRoyaltyPercent;
    }

    // Allows an admin to set a new ERC20 token as the currency for giveaways
    function setERC20Token(IERC20 _erc20Token) public adminRole{
        erc20Token = _erc20Token;
    }
    
    // Allows an admin to remove tokens from the contract
    function removeTokens(address _recipient,IERC20 _token, uint _tokenAmount) public adminRole{
        IERC20(_token).safeTransfer(_recipient, _tokenAmount);
    }

    // Allows an admin to remove Matic/Polygon from the contract
    function removeMatic(address payable _recipient) public adminRole{
        _recipient.transfer(address(this).balance);
    }

    // Allows an admin to add or remove an admin
    function addAdmin(address _address, bool _bool) public adminRole{
        admin[_address] = _bool;
    }

    // Allows an admin to add or remove addresses from the blacklist
    function addBlacklist(address[] memory _address, bool _bool) public adminRole{
        for(uint i=0;i<_address.length;i++){
            blacklist[_address[i]] = _bool;
        }
    }

    // Allows an admin to add or remove addresses from the whitelist
    function addWhitelist(address[] memory _address, bool _bool) public adminRole{
        for(uint i=0;i<_address.length;i++){
            whitelist[_address[i]] = _bool;
        }
    }

    // Allows an admin to enable or disable the whitelist feature
    function setWhitelistEnabled(bool _bool) public adminRole{
        whitelistEnabled = _bool;
    }

    // Allows an admin to enable or disable the creatorFee feature
    function setCreatorFeeEnabled(bool _bool) public adminRole{
        creatorFeeEnabled = _bool;
    }

    // Allows an admin to enable or disable the entryFee feature
    function setEntryFeeEnabled(bool _bool) public adminRole{
        entryFeeEnabled = _bool;
    }

}