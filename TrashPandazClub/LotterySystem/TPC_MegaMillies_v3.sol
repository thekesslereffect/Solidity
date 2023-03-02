// SPDX-License-Identifier: MIT LICENSE
/* MegaMillies Contract by COSMIC ✨ Lord of the TrashPandazClub*/


pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TPC_MegaMillies {




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


    uint ticketNumbers = 6;
    uint ticketNumberValueMax = 20;
    
    function randomGenerator() public view returns (uint[] memory){
        uint[] memory arr = new uint[](ticketNumbers);
        uint[] memory sortedArr = new uint[](ticketNumbers);
        for(uint i=0; i<arr.length; i++){
            arr[i] = uint(keccak256(abi.encodePacked(block.timestamp,i))) % (ticketNumberValueMax + 1) ;
        }
        sortedArr = bubbleSort(arr);
        return sortedArr;
    }

    function bubbleSort(uint[] memory _nums) public pure returns(uint[] memory){
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
    
    function bubbleSortKeccak(uint[] memory _nums) public pure returns(bytes32){
        return keccak256(abi.encodePacked(bubbleSort(_nums)));
    }





















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