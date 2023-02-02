// SPDX-License-Identifier: MIT LICENSE
/* Staking Contract by COSMIC ✨*/
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC1155.sol";

contract MetaSkelez_Staking is IERC721Receiver, ReentrancyGuard, Ownable, Pausable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;   

    // struct to store a stake's token, owner, and earning values
    struct Stake {
        uint24 tokenId;
        uint48 timestamp;
        address owner;
    }

    // reference to the Block NFT contract
    ERC721Enumerable nft; //0xfb6f2e0DC62092B7c44e972773d7BA218b2e1BD2
    IERC20 token; //0xE43c4a30CC4D3292a99cdE82940117dca49DAb75

    // maps tokenId to stake
    mapping(uint256 => Stake) public vault; 
    uint256 public rewardRate; // Tokens / Day
    uint256 public maxWithdrawPercentageOfContract; // 100 = 0.01%, 5000 = 0.5%, 50000 = 5%, 200000 = 20%, etc. PER NFT 
    uint256 public totalStaked;
    uint256 public tokenDecimals; // usually 18

    constructor(ERC721Enumerable _nft, IERC20 _token, uint256 _tokenDecimals) { 
        nft = _nft; 
        token = _token; 
        tokenDecimals = _tokenDecimals;
        rewardRate = 25;
        maxWithdrawPercentageOfContract = 1000;
    }

    function stake(uint256[] calldata tokenIds) external nonReentrant whenNotPaused{
        uint256 tokenId;
        uint256 _len = tokenIds.length;
        totalStaked += _len;
        for (uint i = 0; i < _len; i++) {
            tokenId = tokenIds[i];
            require(nft.ownerOf(tokenId) == msg.sender, "not your token");
            require(vault[tokenId].tokenId == 0, 'already staked');

            nft.transferFrom(msg.sender, address(this), tokenId);
            emit NFTStaked(msg.sender, tokenId, block.timestamp);

            vault[tokenId] = Stake({
                owner: msg.sender,
                tokenId: uint24(tokenId),
                timestamp: uint48(block.timestamp)
            });
        }  
    }

    function _unstakeMany(address account, uint256[] calldata tokenIds) internal {
        uint256 tokenId;
        uint256 _len = tokenIds.length;
        totalStaked -= _len;
        for (uint i = 0; i < _len; i++) {
        tokenId = tokenIds[i];
        Stake memory staked = vault[tokenId];
        require(staked.owner == msg.sender, "not an owner");

        delete vault[tokenId];
        emit NFTUnstaked(account, tokenId, block.timestamp);
        nft.transferFrom(address(this), account, tokenId);
        }
    }

    function claim(uint256[] calldata tokenIds) external {
        _claim(msg.sender, tokenIds, false);
    }

    function claimForAddress(address account, uint256[] calldata tokenIds) external {
        _claim(account, tokenIds, false);
    }

    function unstake(uint256[] calldata tokenIds) external {
        _claim(msg.sender, tokenIds, true);
    }

    function rewardMath(uint256 stakedAt) internal view returns(uint256){
        return ( rewardRate * ( 10 ** tokenDecimals ) * (block.timestamp - stakedAt) / 1 days ) ; 
    }

    function _claim(address account, uint256[] calldata tokenIds, bool _unstake) internal nonReentrant{
        uint256 tokenId;
        uint256 earned = 0;
        uint256 bal = contractRewardBalance();
        uint256 maxWithdraw = bal * maxWithdrawPercentageOfContract/1000000 ; // set max withdraw to % of contract.
        uint256 _len = tokenIds.length;
        for (uint i = 0; i < _len; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            require(staked.owner == account, "not an owner");
            uint256 stakedAt = staked.timestamp;
            uint256 rM = rewardMath(stakedAt);
            if (rM > 0) {
                if (rM < maxWithdraw){
                    earned += rM;
                }
                else{
                     earned += maxWithdraw;
                }
            } else{
                earned += 0;
            }
        }
        if (earned > 0) {
            if(earned < bal){
                token.safeTransfer(msg.sender, earned);             
                //reset vault for tokens
                for (uint i = 0; i < _len; i++) {
                    tokenId = tokenIds[i];
                    vault[tokenId] = Stake({
                        owner: account,
                        tokenId: uint24(tokenId),
                        timestamp: uint48(block.timestamp)
                    });
                }
            } else{
                earned = bal;
                token.safeTransfer(msg.sender, earned);
                for (uint i = 0; i < _len; i++) {
                    tokenId = tokenIds[i];
                    vault[tokenId] = Stake({
                        owner: account,
                        tokenId: uint24(tokenId),
                        timestamp: uint48(block.timestamp)
                    });
                }
            }
        }
        if (_unstake) {
        _unstakeMany(account, tokenIds);
        }
        emit Claimed(account, earned);
    }

    function earningInfo(address account, uint256[] calldata tokenIds) external view returns (uint256[1] memory info) {
        uint256 tokenId;
        uint256 earned = 0;
        uint256 bal = contractRewardBalance();
        uint256 maxWithdraw = bal * maxWithdrawPercentageOfContract/1000000 ; // set max withdraw to % of contract.
        uint256 _len = tokenIds.length;
        for (uint i = 0; i < _len; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            require(staked.owner == account, "not an owner");
            uint256 stakedAt = staked.timestamp;
            uint256 rM = rewardMath(stakedAt);
            if (rM > 0) {
                if (rM < maxWithdraw){
                    earned += rM;
                }
                else{
                     earned += maxWithdraw;
                }
            } else{
                earned += 0;
            }
        }
        return [earned];
    }

    // should never be used inside of transaction because of gas fee
    function balanceOf(address account) public view returns (uint256) {
        uint256 balance = 0;
        uint256 supply = nft.totalSupply();
        for(uint i = 1; i <= supply; i++) {
            if (vault[i].owner == account) {
                balance += 1;
            }
        }
        return balance;
    }

    // should never be used inside of transaction because of gas fee
    function tokensOfOwner(address account) public view returns (uint256[] memory ownerTokens) {

        uint256 supply = nft.totalSupply();
        uint256[] memory tmp = new uint256[](supply);

        uint256 index = 0;
        for(uint tokenId = 1; tokenId <= supply; tokenId++) {
            if (vault[tokenId].owner == account) {
                tmp[index] = vault[tokenId].tokenId;
                index +=1;
            }
        }

        uint256[] memory tokens = new uint256[](index);
        for(uint i = 0; i < index; i++) {
        tokens[i] = tmp[i];
        }

        return tokens;
    }
    
    // check amount of tokens within the contract
    function contractRewardBalance() public view returns (uint256){
        IERC20 x = IERC20(token);
        return x.balanceOf(address(this));
    }

    // check max withdraw amount
    function viewMaxWithdraw() public view returns (uint256){
        uint256 bal = contractRewardBalance();
        uint256 maxWithdraw = bal * maxWithdrawPercentageOfContract/1000000 ;
        return maxWithdraw;
    }

    // MUTATIVE FUNCTIONS

    // set reward amount
    function setReward(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
        emit RewardUpdated(rewardRate);
    }

    //  change the token decimals
    function setTokenDecimals(uint256 _tokenDecimals) external onlyOwner {
        tokenDecimals = _tokenDecimals;
        emit TokenDecimalsUpdated(tokenDecimals);
    }

    // set reward amount
    function updateTokenAddress(IERC20 _token) external onlyOwner {
        token = _token;
        emit TokenAddressUpdated(token);
    }

    // set max percentage of contract funds a person can withdraw
    function setMaxWithdrawPercentageOfContract(uint256 _maxWithdrawPercentageOfContract) external onlyOwner {
        maxWithdrawPercentageOfContract = _maxWithdrawPercentageOfContract;
        emit RewardUpdated(maxWithdrawPercentageOfContract);
    }

    // remove rewards in case of bad actors
    function removeRewardTokens(uint256 _tokenAmount) external onlyOwner{
        token.safeTransfer(msg.sender, _tokenAmount);
    }

    // pause everything
    function pause() external onlyOwner {
        _pause();
    }

    // unpause everything
    function unpause() external onlyOwner {
        _unpause();
    }

    function onERC721Received(
            address,
            address from,
            uint256,
            bytes calldata
        ) external pure override returns (bytes4) {
        require(from == address(0x0), "Cannot send nfts to Vault directly");
        return IERC721Receiver.onERC721Received.selector;
        }
    
    // EVENTS
    event RewardUpdated(uint256 rewardRate);
    event NFTStaked(address owner, uint256 tokenId, uint256 value);
    event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
    event Claimed(address owner, uint256 amount);
    event TokenDecimalsUpdated(uint256 decimals);
    event TokenAddressUpdated(IERC20 token);
}