// SPDX-License-Identifier: MIT LICENSE

/* Ghost Staking Contract by COSMIC ✨ Lord of the TrashPandazClub*/

//                                         J&G57                    !PP&P                              
//                .775555J7~               ^5?:7&  ^Y55557         !B~GY                               
//              .YY!~^:^:~!75!     .7!75555J~:~^!&G?^:^::!5J      7B^#?                                
//             .P5.^Y&@&@@#7:!5!~YPPP!!::::??~PPPG~:!B@&J::GY    ?#^&!                                 
//            :GJ.~P@@@@@@@@&J:!BG!^!::^^^^::::::!^.G@@@@@5:P5. .BJY:                          ^!.     
//            &Y::?@@@@@@@@@@B:::!JP&&&&&&&&&&&&&JJJ5PY7#B&~.#5                               &J7#7    
//            #Y::?@@@@@@@@P!??&&@@@@@@@@@@@@@@@@@@@@@@&&?:::#Y                          !&J: .J5~     
//            #Y::?@@@&&Y!!Y&@@@@@@&PG#@@@@@@@@@@@@@@@@@#&&Y^~JJ.                         !PG5:        
//            #Y:^~???^:~P@@@@@&J7?7Y&#P@@@@@@@@@@@@@@BP#P&&&P~^JY:                         ^5G&.      
//  ::::.     #5:^^::::G@@@@@@?^:::::^J@@@@@@@@@@@@@@&&@7^::!B&G~^J#    ::::::         .75?.  :~       
//  B#5?JYYYYYJ~:^^^^^B@@@@@@7:^^^^^^^7@@@@@@@@@@G?7Y#@&~::^::~B@~:JYYYYJJJJG&:        PP7PP           
//   :JJ~^^^^^::^^^^^:@@@@@@@~:::::::J@@@@@@@@@@@@#B&@@@@#7:::.?@@!:^^^:^75Y~           .!:            
//     .?J!^^^^^^^^^^:@@@@B?@@#!~!~Y&&JYJ&@@@@@@@@@@@@@&Y@@#BP5G&G@~:^:7P!                             
//      .BJ^^^^^^^^^^^J&@&B&BGB@@@@#?:::::B@@G~@@@~G@@B::^Y&@@G5G@@^:^^^!YJ                            
// .  ~JYJ.:::^^^^^^^^::J5YB@&Y55!^^::^^^^:??:^^5~^:??:^^^::JPPGPY^^^::::^P?J.                         
// 7&BJ7!!YYYG!:^^^^^^^^::^~^^::::^^^~~^^^:^^:^:::^^::^^^^^^::^~^:^^:5PYYJ~77P&~                       
//   ~?7?YYYYG~:^^^^^^^^^^^^^^^^^^^:7@@~^:?&B:^~P~^^^::^^^^^^^^^^^^^:5PY!.77??.                        
//     .??~~~::^^^^^^^^^^^^^^^^^^^^^^7@@@P&@@B!@@@7^^?Y:^^^^^^^^^^^^^:^~7Y~                            
//    5B7YYYY5~^^^^^^^^^^^^^^^^^^^^^:~B@@@@@@@@@@@@&@&5:^^^^^^^^^^^^^Y5YYJJ@                           
//    !P! ..  #Y::^^^^^^^^^^^^^^^^^^^^:~~^5B&@@GBB7~!^:^^^^^^^^^^^^:&B^  :Y5       ?~   :7^            
//          ~Y7YP7::^^^^^^^^^^^^^^^^^^^::J~:^!~::::::^^^^^^^^^^^^^^@:             .BPP~YPB7            
//          @~::~!~J^^^^^^^^^^^^^^^^^^^J&@@Y:::^^^^^^^^^^^^^^^^^^^^B7               JPGG5.             
//          @~:^::~7^^^^^^^^^^^^^^^^^:^@@@5^::::::^^^^^^^^^^^^^^^^^:!#~           .&GY:7P#Y            
//          BJ^^^^^:^^^^^^::::::::::^?J@@@P7??????^::::::^^^^^^^^^^^:&7            ::   .:.            
//           &?:^^^^^^^^^:~?J&&&&&&&&@@@@@@@@@@@@@&&&&&#7^^^^^^^^^^^.&7                                
//          BJ^^^^^^^^^^^:J@@@&&&&&&&&@@@Y7??????#&&&&&#?^^^^^^^^^^:#?                                 
//         BJ^:^^^^^^^^^^^:^J?::::::.~@@@!.::::::::::::::^^^^^^^^^^#!                                  
//        ^&^:^^^^^^^^^^^^^^::!!G####&@@@&##########Y!!!:^^^^^^^^^^&^                                  
//       !&:^^^^^^^^^^^^^^^:~#@@@@@@@@@@@@@@@@@@@@@@@@@@5^^^^^^^^^^:@^                                 
//     ^G?:^^^^^^^^^^^^^^^^:^5&@@?:^:!@@@!:^^^^^^^:?YYYJ^^^^^^^^^^^:&!                                 
//     5#.^^^^^^^^^^^^^^^^^^^:^^^^^^:!@@@?::^^^^^^^:::::^^^^^^^^^^^^:&!                                
//    PG:^^^^^^^^^^^^^^^^^^^^^^^^^^^:!@@@@Y^^^^^^^^^^^^^^^^^^^^^^^^^:JP^                               
//    GG:^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~@@@@5:^^^^^^^^^^^^^^^^^^^^^^^^.#5                               

// add a view for the leaderboard

// add erc1155 claim if holiday event is true. Make sure there is a block limit, greater than block.timestamp + 3 Days turns off the event. 
// Store block.timestamp as variable so it can be updated to latest block.timestamp so we can have multiple events 
// variables for the erc1155 holiday event nft so can be changed.


pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RewardToken{
    function mint(address to, uint256 amount) public{}
}

contract GhostStaking is ReentrancyGuard, Ownable, Pausable{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC721Enumerable public nft; //0x1aAA180d4C82aa7EAcEa1FAe8B09BbB8174Cbbf0
    address public token; //0x24C82E859540FA03aE4681e03aC5aFCc4F7f70fE
    uint256 public tokenDecimals; // usually 18
    uint256 public rewardRate = 100; //Trash / Day
    uint256 public maxRewardWithdraw = 100000; //Max Trash per Withdraw. Rewards will reset afterwards. 100000 per withdraw so whales need to constantly come back to withdraw.
    bool public maxMultiplier = true;
    uint256 public maxMultiplierCap = 1000; // 1000 / 10 = 10x max cap
    bool public bonusMultiplier = true; // earn up to % more based on number of pandaz owned.
    uint256 public bonusMultiplierAmount = 10; // extra bonus 10 = 1%, 20 = 2%

    constructor(IERC721Enumerable _nft, address _token, uint256 _tokenDecimals){
        nft = _nft;
        token = _token;
        tokenDecimals = _tokenDecimals;
        //create a null stakers value at index 0
        stakers.push(Stakers(address(0),999999999, block.timestamp));
    }

    uint256[] SM_Multipliers = [
        300,
        5,
        5,
        5,
        5,
        10,
        10
        ];
    uint256[] SM_TokenIds = [
        2028626844729816297473413048497949099433804772995310846604280455040849674265, 
        2028626844729816297473413048497949099433804772995310846604280453941338050908, 
        2028626844729816297473413048497949099433804772995310846604280456140361306460,
        2028626844729816297473413048497949099433804772995310846604280457239873029792,
        2028626844729816297473413048497949099433804772995310846604280458339384657568,
        2028626844729816297473413048497949099433804772995310846604280459438896189788,
        2028626844729816297473413048497949099433804772995310846604280460538407817564
        ];
    address[] public SM_Contracts = [
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963
        ];

    

    event Stake(address _owner);
    event Unstake(address _owner, uint256 _amount);
    event Claim(address _owner, uint256 _amount);

    struct Stakers {
        address owner;
        uint256 tokenId;
        uint256 stakedTime;
    }

    Stakers[] public stakers;

    mapping(uint => uint) public tokenIdToStakersIndex;
    

    struct Leaderboards {
        address owner;
        uint256 totalClaimed;
        uint256 totalStaked;
        
        address[] ownerMem;
        uint256[] totalClaimedMem;
        uint256[] totalStakedMem;
    }
    Leaderboards[] public leaderboards;
    Leaderboards public leaderboardsAll;
    uint256 leaderboardSize = 0;
    mapping(address => Leaderboards) public userStats;


    function updateLeaderboards(uint256 _staked,uint256 _claimed) internal {
        uint _len = leaderboards.length;
        uint _counter = 0;
        //uint _index = 0;
        for(uint i=0; i<_len; i++){
            if(_counter == 0){
                if(leaderboards[i].owner == msg.sender){
                    /// store the info
                    leaderboards[i].totalClaimed += _claimed;
                    leaderboards[i].totalStaked = _staked;
                    userStats[msg.sender] = leaderboards[i];
                    _counter++;
                }
            }
        }
        if(_counter==0){
            Leaderboards memory newEntry;
            newEntry.owner = msg.sender;
            newEntry.totalClaimed += _claimed;
            newEntry.totalStaked = _staked;
            leaderboards.push(newEntry);
            //add to userStats
            userStats[msg.sender] = newEntry;
        }

    }

    function viewLeaderboards() public view returns(address[] memory owners, uint[] memory totalStaked, uint[] memory totalClaimed){
        uint _len = leaderboards.length;
        address[] memory _addr = new address[](_len);
        uint[] memory _staked = new uint[](_len);
        uint[] memory _claimed = new uint[](_len);
        for(uint i=0;i<_len;i++){
            _addr[i] = leaderboards[i].owner;
            _staked[i] = leaderboards[i].totalStaked;
            _claimed[i] = leaderboards[i].totalClaimed;
        }
        return (_addr,_staked,_claimed);
    }

    

    function stake() external nonReentrant whenNotPaused{
        uint _bal = nft.balanceOf(msg.sender);
        require( _bal > 0 );
        uint[] memory _tokenIds = getTokenIdsOfOwner(msg.sender);
        uint _len = _tokenIds.length;
        for (uint i = 0; i < _len; i++) {
            //check if token exists already in stakers. If it does and owner is different, change to new owner and update timestamp, otherwise skip it. Else push to stakers.
            if (tokenIdToStakersIndex[_tokenIds[i]] > 0 ){
                Stakers storage stakedToken = stakers[tokenIdToStakersIndex[_tokenIds[i]]];
                if (stakedToken.owner != msg.sender){
                    stakedToken.owner = msg.sender;
                    stakedToken.stakedTime = block.timestamp;
                }
            }
            else {
                stakers.push(Stakers(msg.sender,_tokenIds[i], block.timestamp));
                tokenIdToStakersIndex[_tokenIds[i]] = stakers.length - 1;
            }
        }
        updateLeaderboards(_bal, 0);
        emit Stake(msg.sender);
    }

    function unstake() external nonReentrant whenNotPaused{
        // Not really needed since staking just overwrites the previous owner info
        require(nft.balanceOf(msg.sender)>0);
        uint[] memory _tokenIds = getTokenIdsOfOwner(msg.sender);
        uint _len = _tokenIds.length;
        uint _rewards = 0;
        for (uint i = 0; i < _len; i++) {
            if (tokenIdToStakersIndex[_tokenIds[i]] > 0 ){
                Stakers storage stakedToken = stakers[tokenIdToStakersIndex[_tokenIds[i]]];
                if (stakedToken.owner == msg.sender){
                    // get timestamp and calculate rewards
                    uint _stakedAt = stakedToken.stakedTime;
                    _rewards += rewardMath(_stakedAt);
                    // reset timestamp
                    stakedToken.stakedTime = block.timestamp;
                    stakedToken.owner = address(0);
                }
            }
        }        
        // get multiplier
        _rewards = _rewards * ( 100 + getMultiplier(msg.sender)) / 100 ;
        // send rewards
        _rewards = sendTokens(_rewards);
        updateLeaderboards(0, _rewards);
        emit Unstake(msg.sender, _rewards);
    }

    function claimRewards() external nonReentrant whenNotPaused{
        uint _bal = nft.balanceOf(msg.sender);
        require( _bal > 0 );
        uint[] memory _tokenIds = getTokenIdsOfOwner(msg.sender);
        uint _len = _tokenIds.length;
        uint _rewards = 0;
        for (uint i = 0; i < _len; i++) {
            if (tokenIdToStakersIndex[_tokenIds[i]] > 0 ){
                Stakers storage stakedToken = stakers[tokenIdToStakersIndex[_tokenIds[i]]];
                if (stakedToken.owner == msg.sender){
                    // get timestamp and calculate rewards
                    uint _stakedAt = stakedToken.stakedTime;
                    _rewards += rewardMath(_stakedAt);
                    // reset timestamp
                    stakedToken.stakedTime = block.timestamp;
                }
            }
        }
        // get multiplier
        _rewards = _rewards * ( 100 + getMultiplier(msg.sender)) / 100 ;
        // send rewards
        _rewards = sendTokens(_rewards);
        updateLeaderboards(_bal, _rewards);
        emit Claim(msg.sender, _rewards);
        return;
    }

    function sendTokens(uint256 _rewardAmount) internal returns(uint256){
        uint _rewards = _rewardAmount;
        if(_rewards>=maxRewardWithdraw * 10 ** tokenDecimals){
            _rewards = maxRewardWithdraw * 10 ** tokenDecimals;
        }
        RewardToken(token).mint(msg.sender,_rewards); // minting from the Trash contract itself.
        return _rewards;
    }

    // Utility functions ///////////////////////////////
    function viewMaxReward() public view returns(uint256){
        return maxRewardWithdraw;
    }

    function setMaxReward(uint _maxReward) public onlyOwner returns(uint){
        maxRewardWithdraw = _maxReward;
        return maxRewardWithdraw;
    }

    function viewAccumulatedRewards(address _account) public view returns(uint256){
        uint[] memory _tokenIds = getTokenIdsOfOwner(_account);
        uint _len = _tokenIds.length;
        uint _rewards = 0;
        for (uint i = 0; i < _len; i++) {
            if (tokenIdToStakersIndex[_tokenIds[i]] > 0 ){
                Stakers storage stakedToken = stakers[tokenIdToStakersIndex[_tokenIds[i]]];
                if (stakedToken.owner == _account){
                    // get timestamp and calculate rewards
                    uint _stakedAt = stakedToken.stakedTime;
                    _rewards += ( (rewardRate * ( 10 ** tokenDecimals ) ) * (block.timestamp - _stakedAt) / 1 days )  ;
                }
            }
        }
        _rewards = _rewards * ( 100 + getMultiplier(_account)) / 100;
        if(_rewards>= maxRewardWithdraw * 10 ** tokenDecimals){
            _rewards = maxRewardWithdraw * 10 ** tokenDecimals;
        }
        return _rewards;
    }

    function rewardMath(uint256 _stakedAt ) internal view returns(uint256){
        uint _reward =  0;
        //_reward = ( (rewardRate * ( 10 ** tokenDecimals ) ) * (block.timestamp - _stakedAt) / 1 days ) * ( 100 + getMultiplier(_account)) / 100 ; // num * (1 + %) = % of num added to num. So we need to add 100 and divide by 100 to remove decimals
        _reward = ( (rewardRate * ( 10 ** tokenDecimals ) ) * (block.timestamp - _stakedAt) / 1 days ); 
        return  _reward; 
    }

    function getMultiplier(address _account) public view returns (uint256){ 
        uint _stakingMultiplier = 0;
        uint256 _totalTokensHeld = 0;
        uint256 _len = SM_Contracts.length;
        for (uint i = 0; i < _len; i++) {
            _totalTokensHeld = walletHoldsToken(_account, SM_Contracts[i], SM_TokenIds[i]);
            _stakingMultiplier += SM_Multipliers[i] * _totalTokensHeld;
        }
        if(maxMultiplier == true){
            if(_stakingMultiplier>maxMultiplierCap){
                _stakingMultiplier = maxMultiplierCap;
            }
        }
        if(bonusMultiplier == true){
            _stakingMultiplier += getBonusMultiplier(_account);
        }
        return _stakingMultiplier;
    }

    function getBonusMultiplier(address _account) internal view returns(uint256){
        // extra bonus 10 = 1%, 20 = 2%, up to 5% extra
        uint256 _bonus = 0;
        uint256 _tokensOwned = nft.balanceOf(_account);
        if(_tokensOwned>=10){_bonus +=bonusMultiplierAmount;}
        if(_tokensOwned>=20){_bonus +=bonusMultiplierAmount;}
        if(_tokensOwned>=30){_bonus +=bonusMultiplierAmount;}
        if(_tokensOwned>=40){_bonus +=bonusMultiplierAmount;}
        if(_tokensOwned>=50){_bonus +=bonusMultiplierAmount;}
        return _bonus;
    }

    function walletHoldsToken(address _account, address _contract, uint256 _id) internal view returns (uint256) {
        IERC1155 token1155 = IERC1155(_contract);
        return token1155.balanceOf(_account, _id); 
    }

    function getTokenIdsOfOwner(address _owner) public view returns(uint[] memory tokensOfOwner){
        uint _len = nft.balanceOf(_owner);
        uint[] memory _tokensOfOwner = new uint[](_len);
        for (uint i = 0; i < _len; i++){
            _tokensOfOwner[i] = nft.tokenOfOwnerByIndex(_owner,i);
        }
        return _tokensOfOwner;
    }

    function getStakedTokenIdsOfOwner(address _owner) public view returns(uint[] memory stakedTokensOfOwner){
        uint[] memory _tokenIds = getTokenIdsOfOwner(_owner);
        uint _len = _tokenIds.length;
        uint[] memory _stakedTokenIds = new uint[](_len);
        uint _stakedCounter = 0;
        for (uint i = 0; i < _len; i++) {
            if (tokenIdToStakersIndex[_tokenIds[i]] > 0 ){
                Stakers storage stakedToken = stakers[tokenIdToStakersIndex[_tokenIds[i]]];
                if (stakedToken.owner == _owner){
                    _stakedTokenIds[_stakedCounter]=stakedToken.tokenId;
                    _stakedCounter++;
                }
            }
        }
        return _stakedTokenIds;
    }

    function getIndexOfStakedTokenIdsOfOwner(address _owner) public view returns(uint[] memory indxeOfStakedTokensOfOwner){
        uint[] memory _tokenIds = getTokenIdsOfOwner(_owner);
        uint _len = _tokenIds.length;
        uint[] memory _stakedTokenIds = new uint[](_len);
        uint _stakedCounter = 0;
        for (uint i = 0; i < _len; i++) {
            if (tokenIdToStakersIndex[_tokenIds[i]] > 0 ){
                Stakers storage stakedToken = stakers[tokenIdToStakersIndex[_tokenIds[i]]];
                if (stakedToken.owner == _owner){
                    _stakedTokenIds[_stakedCounter]=tokenIdToStakersIndex[_tokenIds[i]];
                    _stakedCounter++;
                }
            }
        }
        return _stakedTokenIds;
    }

    function viewOwnerNFTBalance(address _owner) public view returns(uint balanceOfOwner){
        return nft.balanceOf(_owner);
    }

    // OWNER FUNCTIONS /////////////
    // remove tokens from the contract
    function removeTokensFromContract(address _token, uint256 _tokenAmount) external onlyOwner{
        IERC20(_token).safeTransfer(msg.sender, _tokenAmount);
    }

    function setBonusMultiplier(bool _bool, uint _mult) external onlyOwner{
        bonusMultiplier = _bool;
        bonusMultiplierAmount = _mult;
    }

    function setRewardRate(uint _rewardRate) external onlyOwner{
        rewardRate = _rewardRate;
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
    function SM_viewContracts() public view returns (address[] memory) {
        return SM_Contracts;
    }

    function SM_viewTokenIds() public view returns (uint256[] memory) {
        return SM_TokenIds;
    }

    function SM_viewMultipliers() public view returns (uint256[] memory) {
        return SM_Multipliers;
    }

    function setTokenDecimals(uint _tokenDecimals) external onlyOwner{
        tokenDecimals = _tokenDecimals;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }


}