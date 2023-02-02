// SPDX-License-Identifier: MIT LICENSE
/* Swap Base by COSMIC ✨*/
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


interface IStaking{
        function balanceOf(address _account) external view returns(uint256);
    }

contract Trash_Swap is ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;  
    using SafeMath for uint256;

    IERC20 public token1; // token coming in
    IERC20 public token2; // token going out
    ERC721Enumerable public nft; // nft collection for bonus
    address stakingContract; // staking contract to see nfts owner has staked as well

    bool public bonusEnabled = false;
    bool public percentageBonusEnabled = false;
    uint256 public universalBonus = 5;

    constructor(IERC20 _token1, IERC20 _token2, ERC721Enumerable _nft, address _stakingContract){
        token1 = _token1;
        token2 = _token2;
        nft = _nft;
        stakingContract = _stakingContract;
    }

    function swap(uint256 _amount) external nonReentrant whenNotPaused{
        uint256 _token1UserBalance = token1.balanceOf(msg.sender);
        uint256 _token2ContractBalance = token2.balanceOf(address(this));
        uint256 _token1BalanceToSend = _amount;
        uint256 _token2BalanceToSend = _amount;

        if(bonusEnabled){
            uint256 _bonus = getUserBonus(msg.sender);
            _token2BalanceToSend = _amount + (_amount * _bonus / 100)); 
        }

        require (_token1UserBalance > 0, "User does not have tokens to swap.");
        require (_token2ContractBalance > 0, "Contract does not have tokens to send.");
        require (_token2BalanceToSend <= _token2ContractBalance, "Contract does not have enough tokens to match the swap amount.");
        require(token1.allowance(msg.sender, address(this)) >= _amount,"User needs to increase their token1 allowance for this contract address.");
        
        token1.safeTransferFrom(msg.sender,address(this),_token1BalanceToSend);
        token2.safeTransfer(msg.sender, _token2BalanceToSend); 
    }

    // calculate bonus based on nft holdings
    function getUserBonus(address _userAddress) public view returns (uint256){
        uint256 _nftCount = 0;
        uint256 _bonus = 0;
        if(percentageBonusEnabled){
            // get nft holdings in wallet and staking contract
            _nftCount += nft.balanceOf(_userAddress);
            _nftCount += IStaking(stakingContract).balanceOf(_userAddress);

            // create range of percentages
            if(_nftCount == 0){
                _bonus = 0;
            }else if (_nftCount <= 5) {
                _bonus = 1;
            }else if (_nftCount <= 10 && _nftCount > 5) {
                _bonus = 2;
            }else if (_nftCount <= 15 && _nftCount > 10) {
                _bonus = 3;
            }else if (_nftCount <= 20 && _nftCount > 15) {
                _bonus = 4;
            }else if (_nftCount > 20) {
                _bonus = 5;
            }
        } else{
            _bonus = universalBonus;
        }

        // return bonus
        return _bonus;
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

    function setNFTAndStakingAddress(ERC721Enumerable _nft, address _stakingContract) external onlyOwner {
        nft = _nft;
        stakingContract = _stakingContract;
        emit NFTAndStakingAddressesUpdated(nft, stakingContract);
    }

    // enable-disable bonus
    function enableBonus(bool _bool) external onlyOwner {
        bonusEnabled = _bool;
        emit BonusEnableUpdated(bonusEnabled);
    }
    // enable-disable bonus
    function setUniversalBonus(uint256 _amount) external onlyOwner {
        universalBonus = _amount;
        emit UniversalBonusUpdated(universalBonus);
    }
    function enablePercentageBonus(bool _bool) external onlyOwner {
        percentageBonusEnabled = _bool;
        emit PercentageBonusUpdated(percentageBonusEnabled);
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
    event BonusEnableUpdated(bool _bool);
    event UniversalBonusUpdated(uint256 _amount);
    event PercentageBonusUpdated(bool _bool);
    event NFTAndStakingAddressesUpdated(ERC721Enumerable _nft, address _stakingContract);

}