// SPDX-License-Identifier: Unlicense
/* LootBox_Base Contract by COSMIC ✨*/
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract LootBox_Base is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;  

    IERC20 public IERC20Address;
    uint tokenDecimals; // 18
    address public ERC20ReceiverAddress;

    enum TokenType {ERC1155, ERC721, ERC20}
    enum LootBoxTier {Bronze,Silver,Gold,Platinum,Diamond,Legendary}

    bool public releaseKeys; // allow people to open their LootBoxes
    address public lootBoxKeyContractAddr; // ERC1155 key to open LootBoxes

    struct LootBox {
        address owner;
        bool opened;
        LootBoxTier tier;
        uint[] rewards; // not sure if mapping or LootBoxReward[] is better. Or maybe this should be uint[]?
    }

    struct LootBoxReward {
        TokenType tokenType;
        address tokenAddress;
        uint tokenId;
        uint amount;
    }

    uint rewardId = 0;
    uint lootBoxId = 0;
    mapping (uint => LootBox) public lootBoxes; // not sure if better to store uint or address. Uint allows ability to read all lootboxes...
    mapping (uint => LootBoxReward) lootBoxRewards;

    
    constructor(IERC20 _IERC20Address, uint256 _tokenDecimals, address _ERC20ReceiverAddress) { 
        IERC20Address = _IERC20Address; 
        tokenDecimals = _tokenDecimals;
        ERC20ReceiverAddress = _ERC20ReceiverAddress;
    }

    // purchase lootbox
    function PurchaseLootBox(LootBoxTier _tier, uint _cost) external payable nonReentrant returns(LootBox){
        require ( token.balanceOf(msg.sender) >= _cost *10**tokenDecimals); // require buyer has enough tokens
        
        lootBoxId ++; // increment lootbox number by 1

        // generate rewards and assign store them in lootbox
        uint _rewards[20] = FillLootBoxRewards(_tier); // array of 20 just in case they get a lot of prizes

        // generate lootbox and assign id to buyer
        lootBoxes[lootBoxId] = LootBox({
            owner: msg.sender,
            opened: false,
            tier: _tier,
            rewards: _rewards
        });

        IERC20Address.transferFrom(msg.sender,ERC20ReceiverAddress,_cost*10**tokenDecimals); // send funds to staking contract
    }

    function FillLootBoxRewards (LootBoxTier _tier) returns(uint[]){
        uint prizeNumber = 0;
        if(_tier == LootBoxTier.Bronze){
            prizeNumber = 1;
        }

        uint _rewards [prizeNumber];
        for(uint i=0; i < prizeNumber; i++){
            rewardId++;
            _random[4] = PrizeSelector(_tier); // randomly select prize
            lootBoxRewards[rewardId] = LootBoxReward ({
                tokenType: _random[0],
                tokenAddress: _random[1],
                tokenId: _random[2],
                amount: _random[3]
            });
            _rewards.push(rewardId);
        }

        return _rewards;
    }

    function PrizeSelector(LootBoxTier _tier) internal returns(TokenType, address, uint, uint){
        LootBoxReward memory _prize = LootBoxReward();
        if(_tier == LootBoxTier.Bronze){
            //random prize from bronze tier list;
            // remove erc1155/erc721/erc20amount from available tokens
            _prize = LootBoxReward({
                tokenType: _random[0],
                tokenAddress: _random[1],
                tokenId: _random[2],
                amount: _random[3]
            })
        }
        return(_prize.tokenType, _prize.tokenAddress, _prize.tokenId, _prize.amount);
    }

    // purchase lootbox key
    function PurchaseLootBoxKey(LootBoxTier _tier, uint _cost) external payable nonReentrant returns(LootBox){
        require ( IERC20Address.balanceOf(msg.sender) >= _cost *10**tokenDecimals); // require buyer has enough tokens
        // generate lootbox key and assign to buyer
        // send funds to staking contract
    }

    // transfer lootbox if unopened
    function TransferLootBox(address _newOwner, uint _lootBoxId) external {
        require (msg.sender == lootBoxes[_lootBoxId].owner); // require msg.sender is owner of _lootBoxId
        // change LootBox[i].owner to _newOwner
    }

    // open lootbox if keys are released
    function OpenLootBox(uint _lootBoxId, LootBoxTier _tier) external {
        require ( releasedKeys == true, 'Lootbox keys are not released yet.');
        
        // require owner to own lootbox key specific for the tier

        ERC1155Burnable lootBoxKeyContract = ERC1155Burnable(lootBoxKeyContractAddr);

        // assign lootBoxKeyTokenId based on tier
        lootBoxKeyContract.burn(msg.sender, lootBoxKeyTokenId, 1); // burn 1 key

        // send rewards to msg.sender

        // destroy LootBox. Set owner to address(0)?
    }

    function _rand(uint256 offset) public view returns (uint256) {
        uint256 random = 12345; //randomly generate value here
        uint256 seed =
            uint256(
                keccak256(
                    abi.encodePacked(
                        random +
                            block.timestamp +
                            block.difficulty +
                            ((
                                uint256(
                                    keccak256(abi.encodePacked(block.coinbase))
                                )
                            ) / (block.timestamp - offset * block.difficulty)) +
                            block.gaslimit +
                            ((
                                uint256(keccak256(abi.encodePacked(msg.sender)))
                            ) / (block.timestamp + offset * block.number)) +
                            block.number
                    )
                )
            );
        return
            seed.sub(seed.div(totalAvailableSupply).mul(totalAvailableSupply));
    }


}