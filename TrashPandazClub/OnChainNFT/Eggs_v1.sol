// SPDX-License-Identifier: MIT


// TODO
// only mint once per day.
// generate 3 svg images for the image uri

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Hatch{
    function mint(address _sender,uint _tokenId, string memory _chromosome, string memory _rarity) public{}
}

contract Eggs is ERC1155URIStorage, AccessControl{
    using SafeMath for *;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;
    using SafeERC20 for ERC20;

     // Contract name & symbol
    string public name = "TrashPandazClub Eggs";
    string public symbol = "TPCEGG";

    address public hatchContract;
    address public erc20Token;

    uint public mintPrice =10000;

    string public imageURI;
    string[] private imageColors;

    // Rarity percentages
    uint public commonPercent = 60;
    uint public rarePercent = 32;

    struct Token{
        string image;
        string rarity;
        string chromosome;
        uint birthday;
        bool hatched;
    }
    mapping(uint256 => Token) public tokens;
    
    // Restrictions
    // mint once per day
    mapping(address => uint) public recentMint;
    uint public mintCooldown;
    bool public hatchingPaused;
    uint public incubationTime;

    bytes32 public constant BANKER_ROLE = keccak256("BANKER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address _hatchContract, address _erc20Token) ERC1155("")  {
        hatchContract = _hatchContract;
        erc20Token = _erc20Token;
        imageURI = "QmVBcVYSBZGzksdPBBw5bgiqacikZExjkR6MisWHEEDeof";
        imageColors = ["brown.svg","red.svg","green.svg","pink.svg","orange.svg","black.svg","yellow.svg","blue.svg","purple.svg"];
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BANKER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        mintCooldown = 1 days;
        hatchingPaused = true;
        incubationTime = 5 days;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "TPCEgg #', tokenId.toString(), '",',
                '"description": "TrashPandazClub Eggs",',
                '"image": "', tokens[tokenId].image, '",',
                '"attributes": [{"trait_type": "Rarity", "value": "',tokens[tokenId].rarity,'"},{"trait_type": "Hatched", "value": "',getHatched(tokenId),'"},{"trait_type": "Incubation","max_value": 100, "value": ',getIncubationProgress(tokenId).toString(),'}]',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function getHatched(uint _id) public view returns(string memory){
        if(tokens[_id].hatched==false){
            return "UnHatched...";
        } else{
            return "Hatched!";
        }
    }

    function getIncubationProgress(uint _id) public view returns(uint) {
        uint elapsedTime = block.timestamp - tokens[_id].birthday;
        uint progress = elapsedTime * 100 / incubationTime;
        if(progress>100){
            progress = 100;
        }
        return progress;
    }

    function hatch(uint _tokenId) public{
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) != true){
        require(hatchingPaused == true,"Hatching is paused at the moment. Check back later.");
        require(getIncubationProgress(_tokenId) == 100, "It's not ready yet...");
        }
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        require(tokens[_tokenId].hatched==false, "That one is hatched already...");
        tokens[_tokenId].hatched=true;
        updateHatchImage(_tokenId);
        // Mint from gen3 contract
        Hatch(hatchContract).mint(msg.sender,_tokenId,tokens[_tokenId].chromosome,tokens[_tokenId].rarity);
    }

    function updateHatchImage(uint _tokenId) private {
        bytes memory strBytes = bytes(tokens[_tokenId].image);
        bytes memory newBytes = new bytes(strBytes.length - 4);
        for (uint i = 0; i < newBytes.length; i++) {
            newBytes[i] = strBytes[i];
        }
        tokens[_tokenId].image = string(abi.encodePacked(string(newBytes),"_hatched.svg"));
    }

    function mint(address _minter) public {
        if(hasRole(DEFAULT_ADMIN_ROLE, _minter) != true){
        require(block.timestamp - recentMint[_minter] >= mintCooldown, "Slow down there bub! Come back later." );
        require(ERC20(erc20Token).allowance(_minter, address(this)) >= (mintPrice*10**18), "Insufficient allowance");
        ERC20(erc20Token).safeTransferFrom(_minter, address(this), (mintPrice*10**18));  
        }
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        mintStats(newItemId);
        _mint(_minter, newItemId, 1, ""); 
        recentMint[_minter] = block.timestamp;
    }

    function mintFromContract(address _minter) public onlyRole(MINTER_ROLE){
        mint(_minter);
    }

    function mintStats(uint newItemId) private {
        Token memory newToken = Token({
            image: "",
            rarity: "",
            chromosome: "",
            birthday: block.timestamp,
            hatched: false
        });
        tokens[newItemId] = newToken;
        uint _rand = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, newItemId)));
        if((_rand % 2) == 1) {
            tokens[newItemId].chromosome = "XX";
        } else {
            tokens[newItemId].chromosome = "XY";
        }
        if ((_rand % 100) < commonPercent) {
            tokens[newItemId].rarity = "common";
        } else if ((_rand % 100) < (commonPercent + rarePercent)) {
            tokens[newItemId].rarity = "rare";
        } else {
            tokens[newItemId].rarity = "legendary";
        } 
        string memory _color = imageColors[_rand % imageColors.length]; // check this to make sure it gets the right random color
        tokens[newItemId].image = string(abi.encodePacked("ipfs://",imageURI,"/",tokens[newItemId].rarity,"_",_color));
    }

    function setHatchContract(address _contract) public onlyRole(DEFAULT_ADMIN_ROLE){
        hatchContract = _contract;
    } 

    function setHatchingPaused(bool _bool) public onlyRole(DEFAULT_ADMIN_ROLE){
        hatchingPaused = _bool;
    }

    function setIncubationTime(uint _time) public onlyRole(DEFAULT_ADMIN_ROLE){
        incubationTime = _time;
    }

    function setMintCooldown(uint _time) public onlyRole(DEFAULT_ADMIN_ROLE){
        mintCooldown = _time;
    }

    function setImageURI(string memory _imageURI) public onlyRole(DEFAULT_ADMIN_ROLE){
        imageURI = _imageURI;
    }

    function setImageColors(string[] memory _imageColors)public onlyRole(DEFAULT_ADMIN_ROLE){
        imageColors = _imageColors;
    }

    function getTokensOfOwner(address _address) public view returns(uint[] memory){
        uint[] memory _tokens = new uint[](_tokenIds.current());
        uint _count = 0;
        for (uint i=0; i<_tokenIds.current(); i++) 
        {
            // plus 1 because the mint function increments first before minting so the first token id is 1 instead of 0.
            if(balanceOf(_address, i+1)>0){
                _tokens[_count] = i+1; 
                _count++;
            }
        }
        return _tokens;
    }

    function setRarities(uint _common, uint _rare) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(_common+_rare<100, "The total needs to be less than 100 so that Legendary mints happen.");
        commonPercent = _common;
        rarePercent = _rare;
    }

    function removeRewardTokens(uint256 _tokenAmount) external onlyRole(BANKER_ROLE){
        ERC20(erc20Token).safeTransfer(msg.sender, _tokenAmount);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
    

}