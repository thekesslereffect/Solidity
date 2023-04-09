// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ITPCEcoWallet{
    function addERC20Balance(address _account, uint _amount) external;
    function removeERC20Balance(address _account, uint _amount) external;
    function viewERC20BALANCE(address _account) external view returns(uint);
    function viewMATICBALANCE(address _account) external view returns(uint);
}

contract TPCGiveaway_Text {
    using Counters for Counters.Counter;
    Counters.Counter private giveawayIds;
    IERC721 public erc721Token;
    address public ITPCEcoWalletContract;
    mapping(address => bool) admin;
    mapping(address => bool) public blacklist;
    mapping(address => bool) public whitelist;
    bool public whitelistEnabled;
    uint public creatorFee;
    uint public developerFee;
    bool public entryFeeEnabled;
    bool public creatorFeeEnabled;
    bool public erc721TokenEnabled;

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
        uint escrow;
    }
    mapping(uint => Giveaway) public giveaways;

    constructor(address _ITPCEcoWalletContract, IERC721 _erc721Token){
        erc721Token = _erc721Token; // Require Holders can only create giveaways
        ITPCEcoWalletContract = _ITPCEcoWalletContract;
        admin[msg.sender] = true;
        creatorFee = 100000000000000000000; // 100 Tokens
        developerFee = 1; // %
        creatorFeeEnabled = false;
        entryFeeEnabled = false;
        erc721TokenEnabled = true;
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
    modifier ownsERC721Token {
        if(erc721TokenEnabled){
            require(erc721Token.balanceOf(msg.sender) > 0, "Must own an ERC721 token to create a giveaway");
        }
        _;
    }

    // Events ...........................................

    event WinnersPicked(uint giveawayId, address[] winners);
    event GiveawayCreated(uint giveawayId,address creator,uint entryFee, string prize, uint numberOfWinners,uint startTime, uint duration);
    event NewParticipant(uint giveawayaId, address participant);
    event GiveawayDestroyed(uint giveawayId);

    // Functions ........................................

    // Creates a new giveaway with the provided parameters and stores it in the giveaways mapping
    // Deducts the creator fee from the creator's royalties if they have enough, otherwise transfers it from the creator's balance
    // Emits a GiveawayCreated event
    function createGiveaway(uint _entryFee, string memory _prize, uint _numberOfWinners, uint _duration) public blacklisted whitelisted ownsERC721Token{
        if(creatorFeeEnabled) {
            uint feeToPay = creatorFee;
            uint erc20Balance = ITPCEcoWallet(ITPCEcoWalletContract).viewERC20BALANCE(msg.sender);
            require(erc20Balance >= feeToPay, "You dont have enough tokens in your balance.");
            ITPCEcoWallet(ITPCEcoWalletContract).removeERC20Balance(msg.sender,feeToPay);
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
            uint erc20Balance = ITPCEcoWallet(ITPCEcoWalletContract).viewERC20BALANCE(msg.sender);
            require(erc20Balance >= giveaways[_giveawayId].entryFee, "You dont have enough tokens in your balance.");
            ITPCEcoWallet(ITPCEcoWalletContract).removeERC20Balance(msg.sender,giveaways[_giveawayId].entryFee);
            giveaways[_giveawayId].escrow += giveaways[_giveawayId].entryFee;
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
        // Release Escrow minus fee
        uint _escrow = giveaways[_giveawayId].escrow * ( 100 - developerFee ) / 100;
        ITPCEcoWallet(ITPCEcoWalletContract).addERC20Balance(giveaways[_giveawayId].creator, _escrow);
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
    function destroyGiveaway(uint _giveawayId) public adminRole{
        // RESET AND RETURN ALL FUNDS TO USERS
        uint entryFee = giveaways[_giveawayId].entryFee;
        address[] memory participants = giveaways[_giveawayId].participants;
        // Loop through the participants and return their entry fees
        for (uint i = 0; i < participants.length; i++) {
            ITPCEcoWallet(ITPCEcoWalletContract).addERC20Balance(participants[i], entryFee);
        }
        giveaways[_giveawayId].duration = 0;
        address[] memory emptyWinners;
        giveaways[_giveawayId].winners = emptyWinners;
        emit GiveawayDestroyed(_giveawayId);
    }

    // Allows an admin to update the creator fee
    function setCreatorFee(uint _creatorFee) public adminRole{
        creatorFee = _creatorFee;
    }

    // Allows an admin to update the creator royalty percentage
    function setDeveloperFee(uint _developerFee) public adminRole{
        developerFee = _developerFee;
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

    function setITPCEcoWalletContract(address _ITPCEcoWalletContract) public adminRole{
        ITPCEcoWalletContract = _ITPCEcoWalletContract;
    }

    function setERC721Token(IERC721 _erc721Token) public adminRole {
        require(address(_erc721Token) != address(0), "Invalid ERC721 token");
        erc721Token = _erc721Token;
    }

    function setErc721TokenEnabled(bool _bool) public adminRole{
        erc721TokenEnabled = _bool;
    }

}