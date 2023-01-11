// SPDX-License-Identifier: MIT LICENSE
/* TrashPandazClub Steaking V4 🥩 */
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC1155.sol";

contract TrashPandazClubSteakingV5 is IERC721Receiver, ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;

    uint256 public totalStaked;
    
    // struct to store a stake's token, owner, and earning values
    struct Stake {
        uint24 tokenId;
        uint48 timestamp;
        address owner;
    }
    mapping(uint256 => Stake) public vault; 

    // reference to the Block NFT contract
    ERC721Enumerable nft;
    IERC20 token;

    // Leaderboard
    struct Leaderboard {
        bool entered;
        uint256 claimed;
        uint256 multiplier;
        uint256 staked;
        uint256 dailyReward;
    }
    struct LeaderboardDisplay {
        address[] addresses;
        uint256[] values;
    }
    LeaderboardDisplay[] leaderboardDisplay;
    mapping(address => Leaderboard ) public leaderboard;
    mapping(uint => address) public leaderboardIndex;
    uint public totalInLeaderboardIndex;

    // Staking Multiplier Reward Info
    uint256[] SM_Multipliers = [
        300,
        5,
        5,
        5
        ];
    uint256[] SM_TokenIds = [
        2028626844729816297473413048497949099433804772995310846604280455040849674265, 
        2028626844729816297473413048497949099433804772995310846604280453941338050908, 
        2028626844729816297473413048497949099433804772995310846604280456140361306460,
        2028626844729816297473413048497949099433804772995310846604280457239873029792
        ];
    address[] SM_Contracts = [
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963
        ];
    bool public stackMultipliers = false;
    uint256 public rewardRate = 100; //Trash / Day
    uint256 public maxWithdrawPercentageOfContract = 500; // 500 = 0.5%, 5000 = 5%, 20000 = 20%, etc. PER NFT 
    bool public maxMultiplier = true;
    uint256 public maxMultiplierCap = 1000; // 1000 / 10 = 10x max cap
    bool public bonusMultiplier = true; // earn up to 5% more based on number of pandaz owned.

    constructor(ERC721Enumerable _nft, IERC20 _token) { 
        nft = _nft;
        token = _token;
        totalInLeaderboardIndex = 0;
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
        updateLeaderboard(msg.sender,0);
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
    
    function updateLeaderboard(address _account, uint256 _claimAmount) internal{
        Leaderboard memory _leaderboard = leaderboard[_account];
        if(_leaderboard.entered == false){
            leaderboardIndex[totalInLeaderboardIndex] = _account;
            totalInLeaderboardIndex++;
        }
        bool _entered = true;
        uint256 _claimed = _leaderboard.claimed + _claimAmount;
        uint256 _staked = balanceOf(_account);
        uint256 _multiplier = getMultiplier(_account);
        uint256 _dailyReward = ((( rewardRate + (rewardRate * _multiplier / 100 )) * 1 ether ) ) ;
        leaderboard[_account] = Leaderboard({
            entered: _entered,
            claimed: _claimed,
            multiplier: _multiplier,
            staked: _staked,
            dailyReward: _dailyReward
        });
    }

    function getLeaderboard() public view returns(LeaderboardDisplay memory, LeaderboardDisplay memory, LeaderboardDisplay memory, LeaderboardDisplay memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _claimedArray = new uint[](totalInLeaderboardIndex);
        uint[] memory _multiplierArray = new uint[](totalInLeaderboardIndex);
        uint[] memory _stakedArray = new uint[](totalInLeaderboardIndex);
        uint[] memory _dailyArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];    
            _addressArray[i] = _account;
            _claimedArray[i] = leaderboard[_account].claimed;
            _multiplierArray[i] = leaderboard[_account].multiplier;
            _stakedArray[i] = leaderboard[_account].staked;
            _dailyArray[i] = leaderboard[_account].dailyReward;
        }
        LeaderboardDisplay memory leaderboardDisplayClaimed;
        LeaderboardDisplay memory leaderboardDisplayMultipliers;
        LeaderboardDisplay memory leaderboardDisplayStaked;
        LeaderboardDisplay memory leaderboardDisplayDaily;
        (leaderboardDisplayClaimed.addresses, leaderboardDisplayClaimed.values) = sortArrayDecending(_addressArray, _claimedArray);
        (leaderboardDisplayMultipliers.addresses, leaderboardDisplayMultipliers.values) = sortArrayDecending(_addressArray, _multiplierArray);
        (leaderboardDisplayStaked.addresses, leaderboardDisplayStaked.values) = sortArrayDecending(_addressArray, _stakedArray);
        (leaderboardDisplayDaily.addresses, leaderboardDisplayDaily.values) = sortArrayDecending(_addressArray, _dailyArray);
        return (leaderboardDisplayClaimed,leaderboardDisplayMultipliers, leaderboardDisplayStaked,leaderboardDisplayDaily);
    }

    function getClaimedLeaderboard() public view returns(address[] memory, uint[] memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _claimedArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];    
            _addressArray[i] = _account;
            _claimedArray[i] = leaderboard[_account].claimed;
        }
        return sortArrayDecending(_addressArray, _claimedArray);
    }
    function getMultiplierLeaderboard() public view returns(address[] memory, uint[] memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _multiplierArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];           
            _addressArray[i] = _account;
            _multiplierArray[i] = leaderboard[_account].multiplier;
        }
        return sortArrayDecending(_addressArray, _multiplierArray);
    }
    function getStakedLeaderboard() public view returns(address[] memory, uint[] memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _stakedArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];
            _addressArray[i] = _account;
            _stakedArray[i] = leaderboard[_account].staked;
        }
        return sortArrayDecending(_addressArray, _stakedArray);
    }
    function getDailyLeaderboard() public view returns(address[] memory, uint[] memory){
        address[] memory _addressArray = new address[](totalInLeaderboardIndex);
        uint[] memory _dailyArray = new uint[](totalInLeaderboardIndex);
        address _account;
        for(uint i=0; i<totalInLeaderboardIndex; i++){
            _account = leaderboardIndex[i];
            _addressArray[i] = _account;
            _dailyArray[i] = leaderboard[_account].dailyReward;
        }
        return sortArrayDecending(_addressArray, _dailyArray);
    }

    function sortArrayDecending(address[] memory _address, uint[] memory _array) public pure returns(address[] memory, uint[] memory){
        uint[] memory _arr = _array;
        address[] memory _addr = _address;
        uint length = _arr.length;
        for (uint i=0; i<length-1; i++){
            for (uint j=0; j<length-1; j++){
                if(_arr[j]<_arr[j+1]){ // _arr[j]>_arr[j+1] if you want ascending
                    uint current_value = _arr[j];
                    _arr[j] = _arr[j+1];
                    _arr[j+1] = current_value;

                    address current_addr = _addr[j];
                    _addr[j] = _addr[j+1];
                    _addr[j+1] = current_addr;
                }
            }
        }
        return (_addr, _arr);
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

    function rewardMath(address account, uint256 stakedAt) internal view returns(uint256){
        return (((( rewardRate + (rewardRate * getMultiplier(account) / 100 )) * 1 ether ) ) * ( ( block.timestamp - stakedAt ) / 1 days ) );   
    }

    function getMultiplier(address _account) public view returns (uint256){ 
        uint stakingMultiplier = 0;
        uint256 totalTokensHeld = 0;
        uint256 _len = SM_Contracts.length;
        if( stackMultipliers == true ){
            for (uint i = 0; i < _len; i++) {
                totalTokensHeld = walletHoldsToken(_account, SM_Contracts[i], SM_TokenIds[i]);
                stakingMultiplier += SM_Multipliers[i] * totalTokensHeld;
            }
            if(maxMultiplier == true){
                if(stakingMultiplier>maxMultiplierCap){
                    stakingMultiplier = maxMultiplierCap;
                }
            }
        }
        else {
            for (uint i = 0; i < _len; i++) {
                if ( walletHoldsToken(_account, SM_Contracts[i], SM_TokenIds[i]) > 0 ) {
                    stakingMultiplier += SM_Multipliers[i];
                }
            }
            if(maxMultiplier == true){
                if(stakingMultiplier>maxMultiplierCap){
                    stakingMultiplier = maxMultiplierCap;
                }
            }
        }
        if(bonusMultiplier == true){
            stakingMultiplier += getBonusMultiplier(_account);
        }
        return stakingMultiplier;
    }

    function getBonusMultiplier(address _account) internal view returns(uint256){
        // extra bonus 10 = 1%, 20 = 2%, up to 5% extra
        uint256 _bonus = 0;
        uint256 _tokensOwned = nft.balanceOf(_account);
        if(_tokensOwned>10){_bonus +=1;}
        if(_tokensOwned>20){_bonus +=1;}
        if(_tokensOwned>30){_bonus +=1;}
        if(_tokensOwned>40){_bonus +=1;}
        if(_tokensOwned>50){_bonus +=1;}
        return _bonus;
    }

    function walletHoldsToken(address _account, address _contract, uint256 _id) internal view returns (uint256) {
        IERC1155 token1155 = IERC1155(_contract);
        return token1155.balanceOf(_account, _id); 
    }

    function _claim(address _account, uint256[] calldata tokenIds, bool _unstake) internal nonReentrant{
        uint256 tokenId;
        uint256 earned = 0;
        uint256 bal = contractRewardBalance();
        uint256 maxWithdraw = bal * maxWithdrawPercentageOfContract/100000 ; // set max withdraw to % of contract.
        uint256 _len = tokenIds.length;
        for (uint i = 0; i < _len; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            require(staked.owner == _account, "not an owner");
            uint256 stakedAt = staked.timestamp;
            uint256 rM = rewardMath(_account, stakedAt);
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
                        owner: _account,
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
                        owner: _account,
                        tokenId: uint24(tokenId),
                        timestamp: uint48(block.timestamp)
                    });
                }
            }
        }
        if (_unstake) {
        _unstakeMany(_account, tokenIds);
        }
        updateLeaderboard(msg.sender,earned);
        emit Claimed(_account, earned);
    }

    function earningInfo(address account, uint256[] calldata tokenIds) external view returns (uint256[1] memory info) {
        uint256 tokenId;
        uint256 earned = 0;
        uint256 bal = contractRewardBalance();
        uint256 maxWithdraw = bal * maxWithdrawPercentageOfContract/100000 ; // set max withdraw to % of contract.
        uint256 _len = tokenIds.length;
        for (uint i = 0; i < _len; i++) {
            tokenId = tokenIds[i];
            Stake memory staked = vault[tokenId];
            require(staked.owner == account, "not an owner");
            uint256 stakedAt = staked.timestamp;
            uint256 rM = rewardMath(account, stakedAt);
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
    
    function contractRewardBalance() public view returns (uint256){
        IERC20 x = IERC20(token);
        return x.balanceOf(address(this));
    }

    function SM_viewContracts() public view returns (address[] memory) {
        return SM_Contracts;
    }

    function SM_viewTokenIds() public view returns (uint256[] memory) {
        return SM_TokenIds;
    }

    function SM_viewMultipliers() public view returns (uint256[] memory) {
        return SM_Multipliers;
    }

    function viewStackMultipliers() public view returns(bool){
        return stackMultipliers;
    }

    // MUTATIVE FUNCTIONS

    // set reward amount
    function setReward(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
        emit RewardUpdated(rewardRate);
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

    // remove staking multiplier
    function removeSM(uint _index) external onlyOwner{
        require(_index < SM_Contracts.length, "index out of bound");
        uint256 _len = SM_Contracts.length;
        for (uint i = _index; i < _len - 1; i++) {
            SM_Contracts[i] = SM_Contracts[i + 1];
            SM_TokenIds[i] = SM_TokenIds[i + 1];
            SM_Multipliers[i] = SM_Multipliers[i + 1];
        }
        SM_Contracts.pop();
        SM_TokenIds.pop();
        SM_Multipliers.pop();
    }

    // add staking multiplier
    function addSM(address _contract, uint256 _tokenId, uint256 _stakingMultiplier) external onlyOwner{
        SM_Contracts.push(_contract);
        SM_TokenIds.push(_tokenId);
        SM_Multipliers.push(_stakingMultiplier);
    }

    function setStackMultipliers(bool _bool) external onlyOwner{
        stackMultipliers = _bool;
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
}