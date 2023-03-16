pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingContract {
    IERC721 public nft;
    IERC20 public rewardToken;
    uint256 public rewardPerTokenStaked;
    mapping(address => uint256[]) private stakedTokens;
    mapping(uint256 => uint256) private tokenStakeTime;
    mapping(uint256 => bool) private claimed;
    mapping(address => uint256) public rewards;
    
    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(IERC721 _nft, IERC20 _rewardToken, uint256 _rewardPerTokenStaked) {
        nft = _nft;
        rewardToken = _rewardToken;
        rewardPerTokenStaked = _rewardPerTokenStaked;
    }

    function stake() public {
        uint256[] memory tokens = getOwnedTokens();
        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 tokenId = tokens[i];
            if (!isStaked(tokenId)) {
                stakedTokens[msg.sender].push(tokenId);
                tokenStakeTime[tokenId] = block.timestamp;
                emit Staked(msg.sender, tokenId);
            }
        }
    }

    function unstake() public {
        uint256[] memory tokens = stakedTokens[msg.sender];
        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 tokenId = tokens[i];
            if (nft.ownerOf(tokenId) == msg.sender) {
                stakedTokens[msg.sender][i] = stakedTokens[msg.sender][stakedTokens[msg.sender].length - 1];
                stakedTokens[msg.sender].pop();
                uint256 reward = calculateReward(tokenId);
                if (reward > 0) {
                    rewards[msg.sender] += reward;
                    emit RewardPaid(msg.sender, reward);
                }
                tokenStakeTime[tokenId] = 0;
                claimed[tokenId] = false;
                emit Unstaked(msg.sender, tokenId);
            }
        }
    }

    function claim() public {
        uint256[] memory tokens = stakedTokens[msg.sender];
        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 tokenId = tokens[i];
            if (nft.ownerOf(tokenId) == msg.sender && !claimed[tokenId]) {
                uint256 reward = calculateReward(tokenId);
                if (reward > 0) {
                    rewards[msg.sender] += reward;
                    emit RewardPaid(msg.sender, reward);
                }
                claimed[tokenId] = true;
            }
        }
    }
    
    function isStaked(uint256 tokenId) public view returns (bool) {
        for (uint256 i = 0; i < stakedTokens[msg.sender].length; i++) {
            if (stakedTokens[msg.sender][i] == tokenId) {
                return true;
            }
        }
        return false;
    }

    function calculateReward(uint256 tokenId) public view returns (uint256) {
        if (!isStaked(tokenId)) {
            return 0;
        }
        
        uint256 timeStaked = block.timestamp - tokenStakeTime[tokenId];
        return timeStaked * rewardPerTokenStaked;
    }

    function getMostStaked() public view returns (address[] memory, uint256[] memory) {
        address[] memory users = new address[](stakedTokens.length);
        uint256[] memory counts = new uint256[](stakedTokens.length);
        for (uint256 i = 0; i < users.length; i++) {
            users[i] = address(0);
            counts[i] = 0;
        }
        for (uint256 i = 0; i < users.length; i++) {
            address user = stakedTokens[i];
            uint256 count = stakedTokens[user].length;
            for (uint256 j = 0; j < users.length; j++) {
                if (count > counts[j]) {
                    for (uint256 k = users.length - 1; k > j; k--) {
                        users[k] = users[k - 1];
                        counts[k] = counts[k - 1];
                    }
                    users[j] = user;
                    counts[j] = count;
                    break;
                }
            }
        }
        return (users, counts);
    }

    function getMostClaimed() public view returns (address[] memory, uint256[] memory) {
        address[] memory users = new address[](claimed.length);
        uint256[] memory counts = new uint256[](claimed.length);
        for (uint256 i = 0; i < users.length; i++) {
            users[i] = address(0);
            counts[i] = 0;
        }
        for (uint256 i = 0; i < users.length; i++) {
            uint256 tokenId = i + 1;
            address user = nft.ownerOf(tokenId);
            if (claimed[tokenId] && user != address(0)) {
                uint256 count = rewards[user];
                for (uint256 j = 0; j < users.length; j++) {
                    if (count > counts[j]) {
                        for (uint256 k = users.length - 1; k > j; k--) {
                            users[k] = users[k - 1];
                            counts[k] = counts[k - 1];
                        }
                        users[j] = user;
                        counts[j] = count;
                        break;
                    }
                }
            }
        }
        return (users, counts);
    }