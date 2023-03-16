// SPDX-License-Identifier: MIT
// TrashPandazClub TRASH Contract by COSMIC
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract Trash is ERC20, ERC20Capped, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable {
    using SafeERC20 for *;
    // ------------------------------
    // State Variables
    // ------------------------------

    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public totalBurned = 0;
    uint public minimumForMessageTransfer = 10000000000000000000; // = 10 Trash

    // ------------------------------
    // Events
    // ------------------------------

    event TransferWithMessage(address indexed from, address indexed to, uint256 value, string message);
    event TokensBurned(uint256 value, string message);

    // ------------------------------
    // Constructor
    // ------------------------------

    constructor() ERC20("Trash", "TRASH") ERC20Capped(4444000000*10**18){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SNAPSHOT_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    // ------------------------------
    // Public Functions
    // ------------------------------

    function snapshot() public onlyRole(SNAPSHOT_ROLE) {
        _snapshot();
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // ------------------------------
    // Custom ERC20 Functions
    // ------------------------------

    // On-Chain Messages

    struct Message {
        address sender;
        uint256 amount;
        string message;
    }

    mapping(address => Message[]) private messages;

    function transferWithMessage(
        address to, 
        uint256 amount, 
        string memory message
        ) public returns (bool) {
        require(amount>=minimumForMessageTransfer,"You need to send more Trash to do that.");
        _transfer(msg.sender, to, amount);
        Message memory m = Message({
            sender: msg.sender,
            amount: amount,
            message: message
        });
        messages[to].push(m);
        emit TransferWithMessage(msg.sender, to, amount, message);
        return true;
    }

    function getMessages(address recipient) public view returns (Message[] memory) {
        return messages[recipient];
    }

    // Transfer to multiple addresses at once

    function transferMultiple(address[] memory to, uint256 amount) public returns (bool){
        for(uint i=0; i<to.length;i++){
            _transfer(msg.sender, to[i], amount);
        }
        return true;
    }

    function transferWithMessageMultiple(address[] memory to, uint256 amount, string memory message) public returns (bool){
        require(amount>=minimumForMessageTransfer,"You need to send more Trash to do that.");
        for(uint i=0; i<to.length;i++){
            transferWithMessage(to[i], amount, message);
        }
        return true;
    }

    // ------------------------------
    // Setter Functions
    // ------------------------------

    function setMinimumForMessageTransfer(uint _min) public onlyRole(DEFAULT_ADMIN_ROLE){
        minimumForMessageTransfer = _min;
    }

    // ------------------------------
    // Internal Functions
    // ------------------------------

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20, ERC20Snapshot)
    {
        require(to != address(this), "You are not allowed to send tokens to this address.");
        super._beforeTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Capped)
    {
        super._mint(to, amount);
    }

    function _burn(address from, uint256 amount)
        internal
        override(ERC20)
    {
        totalBurned += amount;
        emit TokensBurned(amount, "Burn Baby Burnnn!!!");
        super._burn(from, amount);
    }


}