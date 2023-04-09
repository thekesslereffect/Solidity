// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TPCReputation is AccessControl {
    struct Account {
        uint upvotes;
        mapping(address=>uint) lastUpvote;
        uint lastUpvoteTimestamp;
    }
    mapping(address => Account) private accounts;
    address[] private accountList;
    uint private decayRate; // Decay rate in seconds
    uint private sameAddressCooldown;
    
    constructor(){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        decayRate = 86400; // 1 day
        sameAddressCooldown = 300; // 5 minutes
    }

    // Events ...........................................

    event Upvoted(address indexed giver, address indexed account);

    // Functions ........................................

    function upvote(address account) public {
        require(account != msg.sender, "You cant upvote yourself.");

        uint lastUpvote = accounts[account].lastUpvote[msg.sender];
        require(block.timestamp >= lastUpvote + sameAddressCooldown, "Too many upvotes to this address. Please wait before trying again.");
        
        uint currentUpvotes = getUpvotes(account);
        accounts[account].upvotes = currentUpvotes + 1;
        accounts[account].lastUpvote[msg.sender] = block.timestamp;
        accounts[account].lastUpvoteTimestamp = block.timestamp;
        
        if (currentUpvotes == 0) {
            accountList.push(account);
        }
        
        emit Upvoted(msg.sender, account);
    }


    function getUpvotes(address account) public view returns (uint) {
        uint upvotes = accounts[account].upvotes;
        uint lastUpvoteTimestamp = accounts[account].lastUpvoteTimestamp;
        uint timePassed = block.timestamp - lastUpvoteTimestamp;
        uint decayedUpvotes = timePassed / decayRate;
        return upvotes > decayedUpvotes ? upvotes - decayedUpvotes : 0;
    }

    function viewAllAccounts() public view returns (address[] memory, uint[] memory) {
        uint length = accountList.length;
        address[] memory allAccounts = new address[](length);
        uint[] memory upvotes = new uint[](length);
        for (uint i = 0; i < length; i++) {
            address account = accountList[i];
            allAccounts[i] = account;
            upvotes[i] = getUpvotes(account);
        }
        return (allAccounts, upvotes);
    }

    function setDecayRate(uint _decayRate) public onlyRole(DEFAULT_ADMIN_ROLE){
        decayRate = _decayRate;
    }

    function setSameAddressCooldown(uint _sameAddressCooldown) public onlyRole(DEFAULT_ADMIN_ROLE){
        sameAddressCooldown = _sameAddressCooldown;
    }
}
