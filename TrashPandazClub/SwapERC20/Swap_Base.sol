// SPDX-License-Identifier: MIT LICENSE
/* Swap Base by COSMIC ✨*/
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Trash_Swap is ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;  

    IERC20 public token1; // token coming in
    IERC20 public token2; // token going out
    address stakingContract; // staking contract to see nfts owner has staked as well

    bool public bonusEnabled = false;
    uint256 public bonus = 5; // percent extra they can earn by swapping

    constructor(IERC20 _token1, IERC20 _token2){
        token1 = _token1;
        token2 = _token2;
    }

    function swap(uint256 _amount) external nonReentrant whenNotPaused{
        uint256 _token1UserBalance = token1.balanceOf(msg.sender);
        uint256 _token2ContractBalance = token2.balanceOf(address(this));
        uint256 _token1BalanceToSend = _amount;
        uint256 _token2BalanceToSend = _amount;

        if(bonusEnabled){
            _token2BalanceToSend = _amount + (_amount * bonus/100); 
        }

        require (_token1UserBalance > 0, "User does not have tokens to swap.");
        require (_token2ContractBalance > 0, "Contract does not have tokens to send.");
        require (_token2BalanceToSend <= _token2ContractBalance, "Contract does not have enough tokens to match the swap amount.");
        require(token1.allowance(msg.sender, address(this)) >= _amount,"User needs to increase their token1 allowance for this contract address.");
        
        token1.safeTransferFrom(msg.sender,address(this),_token1BalanceToSend);
        token2.safeTransfer(msg.sender, _token2BalanceToSend); 
    }


    // VIEW FUNCTIONS
    function contractToken1Balance() public view returns (uint256){
        return token1.balanceOf(address(this));
    }
    function contractToken2Balance() public view returns (uint256){
        return token2.balanceOf(address(this));
    }

    // MUTATIVE FUNCTIONS
    function setTokenAddress(IERC20 _token1, IERC20 _token2) external onlyOwner {
        token1 = _token1;
        token2 = _token2;
        emit TokenAddressesUpdated(token1, token2);
    }

    // enable-disable bonus
    function enableBonus(bool _bool, uint256 _amount) external onlyOwner {
        bonusEnabled = _bool;
        bonus = _amount;
        emit BonusEnableUpdated(bonusEnabled, bonus);
    }
    // enable-disable bonus
    function setBonus(uint256 _amount) external onlyOwner {
        bonus = _amount;
        emit bonusUpdated(bonus);
    }

    // remove rewards in case of bad actors
    function removeTokens(IERC20 _tokenAddress, uint256 _tokenAmount) external onlyOwner{
        _tokenAddress.safeTransfer(msg.sender, _tokenAmount);
    }

    // pause everything
    function pause() external onlyOwner {
        _pause();
    }

    // unpause everything
    function unpause() external onlyOwner {
        _unpause();
    }

    event TokenAddressesUpdated(IERC20 _token1, IERC20 _token2);
    event BonusEnableUpdated(bool _bool, uint256 _amount);
    event bonusUpdated(uint256 _amount);
    event PercentageBonusUpdated(bool _bool);

}