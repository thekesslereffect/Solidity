// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// library TPCGen3_ColorLib {
//     function getColorsCommon() public pure returns(string[4][5] memory){
//         string[4][5] memory colors = [
//             ['"#232428"','"#302940"','"#422333"','"#76192d"'],
//             ['"#335056"','"#404b67"','"#65474c"','"#ab2c2c"'],
//             ['"#5a8a8f"','"#588195"','"#7b6561"','"#ed553b"'],
//             ['"#9dbe9f"','"#9dbfbb"','"#bd9680"','"#f09a59"'],
//             ['"#f7f0e9"','"#e5f5e7"','"#efead4"','"#f0ddb8"']
//         ];
//         return colors;
//     }
//     function getColorsRare() public pure returns(string[4][5] memory){
//         string[4][5] memory colors = [
//             ['"#101000"','"#102000"','"#103000"','"#104000"'],
//             ['"#111000"','"#112000"','"#113000"','"#114000"'],
//             ['"#121000"','"#122000"','"#123000"','"#124000"'],
//             ['"#131000"','"#132000"','"#133000"','"#134000"'],
//             ['"#141000"','"#142000"','"#143000"','"#144000"']
//         ];
//         return colors;

//     }
//     function getColorsLegendary() public pure returns(string[4][5] memory){
//         string[4][5] memory colors = [
//             ['"#201000"','"#202000"','"#203000"','"#204000"'],
//             ['"#211000"','"#212000"','"#213000"','"#214000"'],
//             ['"#221000"','"#222000"','"#223000"','"#224000"'],
//             ['"#231000"','"#232000"','"#233000"','"#234000"'],
//             ['"#241000"','"#242000"','"#243000"','"#244000"']
//         ];
//         return colors;
//     }
// }

library TPCGen3_ColorLib {
    function getColorsCommon() public pure returns(string[4][5] memory){
        string[4][5] memory colors = [
            ['"#232428"','"#302940"','"#422333"','"#76192d"'],
            ['"#335056"','"#404b67"','"#65474c"','"#ab2c2c"'],
            ['"#5a8a8f"','"#588195"','"#7b6561"','"#ed553b"'],
            ['"#9dbe9f"','"#9dbfbb"','"#bd9680"','"#f09a59"'],
            ['"#f7f0e9"','"#e5f5e7"','"#efead4"','"#f0ddb8"']
        ];
        return colors;
    }
    function getColorsRare() public pure returns(string[4][5] memory){
        string[4][5] memory colors = [
            ['"#101000"','"#102000"','"#103000"','"#104000"'],
            ['"#111000"','"#112000"','"#113000"','"#114000"'],
            ['"#121000"','"#122000"','"#123000"','"#124000"'],
            ['"#131000"','"#132000"','"#133000"','"#134000"'],
            ['"#141000"','"#142000"','"#143000"','"#144000"']
        ];
        return colors;

    }
    function getColorsLegendary() public pure returns(string[4][5] memory){
        string[4][5] memory colors = [
            ['"#201000"','"#202000"','"#203000"','"#204000"'],
            ['"#211000"','"#212000"','"#213000"','"#214000"'],
            ['"#221000"','"#222000"','"#223000"','"#224000"'],
            ['"#231000"','"#232000"','"#233000"','"#234000"'],
            ['"#241000"','"#242000"','"#243000"','"#244000"']
        ];
        return colors;
    }
}

contract Gen3Generator{
    function generateCharacter(string[5] memory _color, string memory _chromosome, bool _mutated) public returns(string memory) {}
}


contract TPCGen3 is ERC1155URIStorage, AccessControl{
    using SafeMath for *;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;

     // Contract name & symbol
    string public name = "TrashPandazClub Gen3";
    string public symbol = "TPCGEN3";
    string public description = "Get ready for the TrashPandazClub Gen3 NFT collection, an exciting world of pixel art that will leave you wanting more! Hurry to trashpandazclub.com and mint your own one-of-a-kind TrashPandaz with exclusive mutations, eye-catching patterns, and vibrant color palettes. Dont miss out on this fantastic opportunity to join the hype, elevate your NFT collection, and become an integral part of the ever-growing TrashPandazClub community!";

    address gen3GeneratorContract;

    string public imageURI;
    string[] private imageColors;

    // Rarity percentages
    uint public commonPercent = 70;
    uint public rarePercent = 25;

    struct Token{
        string image;
        string rarity;
        string chromosome;
        uint birthday;
        bool hatched;
        string[5] color;
        uint rand;
        bool mutated;
        uint exp;
    }
    mapping(uint256 => Token) public tokens;
    mapping(string => string[4][5]) rarityToColors;

    bool public hatchingPaused;
    uint public incubationTime;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant MUTATION_ROLE = keccak256("MUTATION_ROLE");

    constructor(address _gen3GeneratorContract) ERC1155("")  {
        imageURI = "QmX2SiSVtSWLemBcpQLi4iUWAkhq3XZ39RstX3zr8inFGB";
        imageColors = ["brown.svg","red.svg","green.svg","pink.svg","orange.svg","black.svg","yellow.svg","blue.svg","purple.svg"];
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MUTATION_ROLE, msg.sender);
        hatchingPaused = true;
        incubationTime = 2 days;
        rarityToColors["common"] = TPCGen3_ColorLib.getColorsCommon();
        rarityToColors["rare"] = TPCGen3_ColorLib.getColorsRare();
        rarityToColors["legendary"] = TPCGen3_ColorLib.getColorsLegendary();
        gen3GeneratorContract = _gen3GeneratorContract;
    }

    // ChatGPT Stack too deep solution?
    function tokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            _tokenURIPrefix(tokenId),
            _tokenURIPayload(tokenId),
            _tokenURISuffix()
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function _tokenURIPrefix(uint256 tokenId) private view returns (string memory) {
        return string(
                abi.encodePacked(
                    '{ "name": "TPCGen3 #',tokenId.toString(),
                    '", "description": "',
                    description,
                    '", "image": "',
                    tokens[tokenId].image
                    )
                );
    }

    function _tokenURIPayload(uint256 tokenId) private view returns (string memory) {
        if (tokens[tokenId].hatched == false) {
            return string(
                abi.encodePacked(
                    '", "attributes": [{"trait_type": "Rarity", "value": "',
                    tokens[tokenId].rarity,
                    '"},{"trait_type": "Chromosome", "value": "',
                    tokens[tokenId].chromosome,
                    '"},{"trait_type": "Incubation","max_value": 100, "value": ',
                    getIncubationProgress(tokenId).toString(),
                    '}]'
                )
            );
        } else {
            return string(
                abi.encodePacked(
                    '", "attributes": [{"trait_type": "Rarity", "value": "',
                    tokens[tokenId].rarity,
                    '"},{"trait_type": "Chromosome", "value": "',
                    tokens[tokenId].chromosome,
                    '"},{"trait_type": "Color 1", "value": ',
                    tokens[tokenId].color[0],
                    '},{"trait_type": "Color 2", "value": ',
                    tokens[tokenId].color[1],
                    '},{"trait_type": "Color 3", "value": ',
                    tokens[tokenId].color[2],
                    '},{"trait_type": "Color 4", "value": ',
                    tokens[tokenId].color[3],
                    '},{"trait_type": "Color 5", "value": ',
                    tokens[tokenId].color[4],
                    '}]'
                )
            );
        }
    }

    function _tokenURISuffix() private pure returns (string memory) {
        return '}';
    }

    function getIncubationProgress(uint _tokenId) public view returns(uint) {
        uint elapsedTime = block.timestamp - tokens[_tokenId].birthday;
        uint progress = elapsedTime * 100 / incubationTime;
        if(progress>100){
            progress = 100;
        }
        return progress;
    }

    function hatch(uint _tokenId) public{
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) == false){
            require(hatchingPaused == false,"Hatching is paused at the moment. Check back later.");
            require(getIncubationProgress(_tokenId) == 100, "It's not ready yet...");
        }
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        require(tokens[_tokenId].hatched==false, "That one is hatched already...");
        tokens[_tokenId].hatched=true;
        if(keccak256(abi.encodePacked(tokens[_tokenId].rarity)) != keccak256(abi.encodePacked("collab"))){
            if(tokens[_tokenId].mutated != true){
                generateColorByRarity(tokens[_tokenId].rand,tokens[_tokenId].rarity,_tokenId);
            }
        }
        tokens[_tokenId].image = Gen3Generator(gen3GeneratorContract).generateCharacter(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated);
    }

    function generateColorByRarity(uint _rand, string memory _rarity, uint _tokenId) private {
        string[4][5] memory colors = rarityToColors[_rarity];
        //num-colors = 5 num-shades = 4
        uint[5] memory indices = [_rand % 4, (_rand >> 32) % 4, (_rand >> 64) % 4, (_rand >> 96) % 4, (_rand >> 128) % 4];
        tokens[_tokenId].color[0] = colors[0][indices[0]];
        tokens[_tokenId].color[1] = colors[1][indices[1]];
        tokens[_tokenId].color[2] = colors[2][indices[2]];
        tokens[_tokenId].color[3] = colors[3][indices[3]];
        tokens[_tokenId].color[4] = colors[4][indices[4]];
    }

    function customColorForLegendary(uint _tokenId, string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5) public {
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        require(keccak256(abi.encodePacked(tokens[_tokenId].rarity)) == keccak256((abi.encodePacked("legendary"))), "Only Legendary TrashPandaz can be customized");
        tokens[_tokenId].color[0] = string(abi.encodePacked('"',_color1,'"'));
        tokens[_tokenId].color[1] = string(abi.encodePacked('"',_color2,'"'));
        tokens[_tokenId].color[2] = string(abi.encodePacked('"',_color3,'"'));
        tokens[_tokenId].color[3] = string(abi.encodePacked('"',_color4,'"'));
        tokens[_tokenId].color[4] = string(abi.encodePacked('"',_color5,'"'));
    }

    function mint(address _minter) public onlyRole(MINTER_ROLE){
        _tokenIds.increment();
        uint256 _newItemId = _tokenIds.current();
        mintStats(_newItemId);
        _mint(_minter, _newItemId, 1, ""); 
    }

    function mintStats(uint _newItemId) private {
        Token memory newToken = Token({
            image: "",
            rarity: "",
            chromosome: "",
            birthday: block.timestamp,
            hatched: false,
            color: ["???","???","???","???","???"],
            rand: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId))),
            mutated: false,
            exp: 0
        });
        tokens[_newItemId] = newToken;
        if((tokens[_newItemId].rand % 2) == 1) {
            tokens[_newItemId].chromosome = "XX";
        } else {
            tokens[_newItemId].chromosome = "XY";
        }
        if ((tokens[_newItemId].rand % 100) < commonPercent) {
            tokens[_newItemId].rarity = "common";
        } else if ((tokens[_newItemId].rand % 100) < (commonPercent + rarePercent)) {
            tokens[_newItemId].rarity = "rare";
        } else {
            tokens[_newItemId].rarity = "legendary";
        } 
        string memory _color = imageColors[tokens[_newItemId].rand % imageColors.length];
        tokens[_newItemId].image = string(abi.encodePacked("ipfs://",imageURI,"/",tokens[_newItemId].rarity,"_",_color));
    }

    function mintCollab(address _minter, string memory _projectName, string[5] memory _colors) public onlyRole(DEFAULT_ADMIN_ROLE){
        _tokenIds.increment();
        uint256 _newItemId = _tokenIds.current();
        mintStatsCollab(_newItemId,_projectName,_colors);
        _mint(_minter, _newItemId, 1, ""); 
    }

    function mintStatsCollab(uint _newItemId, string memory _projectName, string[5] memory _colors) private {
        string[5] memory _colorsArray;
        _colorsArray[0] = string(abi.encodePacked('"',_colors[0],'"'));
        _colorsArray[1] = string(abi.encodePacked('"',_colors[1],'"'));
        _colorsArray[2] = string(abi.encodePacked('"',_colors[2],'"'));
        _colorsArray[3] = string(abi.encodePacked('"',_colors[3],'"'));
        _colorsArray[4] = string(abi.encodePacked('"',_colors[4],'"'));
        Token memory newToken = Token({
            image: string(abi.encodePacked("ipfs://",imageURI,"/","collab_collab.svg")),
            rarity: "collab",
            chromosome: _projectName,
            birthday: block.timestamp,
            hatched: false,
            color: _colorsArray,
            rand: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId))),
            mutated: false,
            exp: 0
        });
        tokens[_newItemId] = newToken;
    }

    function mutate(uint _tokenId,string memory _chromosome, string[5] memory _colors) public onlyRole(MUTATION_ROLE){
        require(tokens[_tokenId].mutated==false,"This NFT has already has mutated DNA.");
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        tokens[_tokenId].chromosome = _chromosome;
        string[5] memory _colorsArray;
        _colorsArray[0] = string(abi.encodePacked('"',_colors[0],'"'));
        _colorsArray[1] = string(abi.encodePacked('"',_colors[1],'"'));
        _colorsArray[2] = string(abi.encodePacked('"',_colors[2],'"'));
        _colorsArray[3] = string(abi.encodePacked('"',_colors[3],'"'));
        _colorsArray[4] = string(abi.encodePacked('"',_colors[4],'"'));
        tokens[_tokenId].color = _colorsArray;
        tokens[_tokenId].mutated=true;
        if(tokens[_tokenId].hatched == true){
            tokens[_tokenId].image = Gen3Generator(gen3GeneratorContract).generateCharacter(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated);
        }
    }

    function setHatchingPaused(bool _bool) public onlyRole(DEFAULT_ADMIN_ROLE){
        hatchingPaused = _bool;
    }

    function setIncubationTime(uint _time) public onlyRole(DEFAULT_ADMIN_ROLE){
        incubationTime = _time;
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

    function setGen3GeneratorContract(address _gen3GeneratorContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3GeneratorContract = _gen3GeneratorContract;
    }

    function setDescription(string memory _description) public onlyRole(DEFAULT_ADMIN_ROLE){
        description = _description;
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