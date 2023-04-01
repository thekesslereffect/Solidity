// SPDX-License-Identifier: MIT
// DEPLOY
// gas               5936182
// transaction cost  5161897
// execution cost    4749189
// MINT
// gas              17469540
// transaction cost 15190924
// execution cost   15169860
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

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
    function getColorsEpic() public pure returns(string[4][5] memory){
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
library TPCGen3_Image1 {

function generateCharacter(string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5 ) public pure returns(string memory){


        // stack too deep so we need to split this bitch up
        string memory result = "";
        {
            result = string(abi.encodePacked(
                '<svg width="128" height="128" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">',
                '<rect x="8" y="0" width="8" height="8" fill=',_color2,'/>',
                '<rect x="16" y="0" width="16" height="8" fill=',_color4,'/>',
                '<rect x="32" y="0" width="64" height="8" fill=',_color2,'/>',
                '<rect x="96" y="0" width="16" height="8" fill=',_color4,'/>',
                '<rect x="112" y="0" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="8" y="8" width="8" height="8" fill=',_color4,'/>',
                '<rect x="16" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="24" y="8" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="8" width="16" height="8" fill=',_color4,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="48" y="8" width="32" height="8" fill=',_color3,'/>',
                '<rect x="80" y="8" width="16" height="8" fill=',_color4,'/>',
                '<rect x="96" y="8" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="112" y="8" width="8" height="8" fill=',_color4,'/>',
                '<rect x="120" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="8" y="16" width="8" height="8" fill=',_color4,'/>',
                '<rect x="16" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="24" y="16" width="24" height="8" fill=',_color4,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="48" y="16" width="32" height="8" fill=',_color3,'/>',
                '<rect x="80" y="16" width="24" height="8" fill=',_color4,'/>',
                '<rect x="104" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="112" y="16" width="8" height="8" fill=',_color4,'/>',
                '<rect x="120" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="0" y="24" width="8" height="8" fill=',_color3,'/>',
                '<rect x="8" y="24" width="24" height="8" fill=',_color4,'/>',
                '<rect x="32" y="24" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="24" width="16" height="8" fill=',_color4,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="56" y="24" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="24" width="16" height="8" fill=',_color4,'/>',
                '<rect x="88" y="24" width="8" height="8" fill=',_color5,'/>',
                '<rect x="96" y="24" width="24" height="8" fill=',_color4,'/>',
                '<rect x="120" y="24" width="8" height="8" fill=',_color3,'/>',
                '<rect x="0" y="32" width="8" height="8" fill=',_color2,'/>',
                '<rect x="8" y="32" width="32" height="8" fill=',_color4,'/>',
                '<rect x="40" y="32" width="8" height="8" fill=',_color5,'/>',
                '<rect x="48" y="32" width="8" height="8" fill=',_color4,'/>'
                
            ));

        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="56" y="32" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="32" width="8" height="8" fill=',_color4,'/>',
                '<rect x="80" y="32" width="8" height="8" fill=',_color5,'/>',
                '<rect x="88" y="32" width="32" height="8" fill=',_color4,'/>',
                '<rect x="120" y="32" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="40" width="8" height="8" fill=',_color2,'/>',
                '<rect x="8" y="40" width="16" height="8" fill=',_color4,'/>',
                '<rect x="24" y="40" width="32" height="8" fill=',_color5,'/>',
                '<rect x="56" y="40" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="40" width="32" height="8" fill=',_color5,'/>'
                
            ));        
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="104" y="40" width="16" height="8" fill=',_color4,'/>',
                '<rect x="120" y="40" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="16" y="48" width="8" height="8" fill=',_color5,'/>'
                '<rect x="24" y="48" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="48" y="48" width="32" height="8" fill=',_color3,'/>'
                
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="80" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="96" y="48" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="48" width="8" height="8" fill=',_color5,'/>',
                '<rect x="112" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="0" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="16" y="56" width="8" height="8" fill=',_color3,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="24" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="48" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="56" y="56" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="80" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="88" y="56" width="8" height="8" fill=',_color5,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="96" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="112" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="120" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="0" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="16" y="48" width="8" height="8" fill=',_color5,'/>',
                '<rect x="24" y="48" width="8" height="8" fill=',_color3,'/>'
                
            ));

        }
        


        
        return result;
    }
}

library TPCGen3_Image2 {

function generateCharacter(string memory _result, string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5, string memory _levels, string memory _chromosome ) public pure returns(string memory){
        if (keccak256(abi.encodePacked(_chromosome)) == keccak256(abi.encodePacked("XX")) ){
            _chromosome = _color1;
        }else{
            _chromosome = _color3;
        }

        string memory result = _result;
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="32" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="48" y="48" width="32" height="8" fill=',_color3,'/>',
                '<rect x="80" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="96" y="48" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="48" width="8" height="8" fill=',_color5,'/>',
                '<rect x="112" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="0" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="16" y="56" width="8" height="8" fill=',_color3,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="24" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="48" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="56" y="56" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="80" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="88" y="56" width="8" height="8" fill=',_color5,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="96" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="112" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="120" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="0" y="64" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="64" width="16" height="8" fill=',_chromosome,'/>',
              '<rect x="24" y="64" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="64" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="64" width="8" height="8" fill=',_color3,'/>',
                '<rect x="48" y="64" width="8" height="8" fill=',_color5,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="56" y="64" width="16" height="8" fill=',_color4,'/>',
                '<rect x="72" y="64" width="8" height="8" fill=',_color5,'/>',
                '<rect x="80" y="64" width="8" height="8" fill=',_color3,'/>',
                '<rect x="88" y="64" width="8" height="8" fill=',_color5,'/>',
              '<rect x="96" y="64" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="64" width="16" height="8" fill=',_chromosome,'/>',
                '<rect x="120" y="64" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="72" width="8" height="8" fill=',_color5,'/>',
                '<rect x="16" y="72" width="24" height="8" fill=',_color3,'/>',
                '<rect x="40" y="72" width="48" height="8" fill=',_color5,'/>'
                
                  
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="88" y="72" width="24" height="8" fill=',_color3,'/>',
                '<rect x="112" y="72" width="8" height="8" fill=',_color5,'/>',
                '<rect x="0" y="80" width="8" height="8" fill=',_color2,'/>',
              '<rect x="8" y="80" width="8" height="8" fill=',_color1,'/>',
                '<rect x="16" y="80" width="96" height="8" fill=',_color5,'/>',
                '<rect x="112" y="80" width="8" height="8" fill=',_color1,'/>',
                '<rect x="120" y="80" width="8" height="8" fill=',_color2,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="0" y="88" width="8" height="8" fill=',_color1,'/>',
                '<rect x="8" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="16" y="88" width="16" height="8" fill=',_color2,'/>',
                '<rect x="32" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="40" y="88" width="8" height="8" fill=',_color5,'/>',
                '<rect x="48" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="56" y="88" width="8" height="8" fill=',_color5,'/>',
              '<rect x="64" y="88" width="16" height="8" fill=',_color4,'/>',
                '<rect x="80" y="88" width="8" height="8" fill=',_color5,'/>',
                '<rect x="88" y="88" width="8" height="8" fill=',_color4,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="96" y="88" width="16" height="8" fill=',_color2,'/>',
                '<rect x="112" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="120" y="88" width="8" height="8" fill=',_color1,'/>',
                '<rect x="0" y="96" width="8" height="8" fill=',_color1,'/>',
                '<rect x="8" y="96" width="16" height="8" fill=',_color4,'/>',
                '<rect x="24" y="96" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="96" width="64" height="8" fill=',_color5,'/>',
              '<rect x="96" y="96" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="96" width="16" height="8" fill=',_color4,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="120" y="96" width="8" height="8" fill=',_color1,'/>',
                '<rect x="8" y="104" width="16" height="8" fill=',_color1,'/>',
                '<rect x="24" y="104" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="104" width="16" height="8" fill=',_color4,'/>',
                '<rect x="48" y="104" width="32" height="8" fill=',_color5,'/>',
                '<rect x="80" y="104" width="16" height="8" fill=',_color4,'/>',
                '<rect x="96" y="104" width="8" height="8" fill=',_color3,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="104" y="104" width="16" height="8" fill=',_color1,'/>',
                '<rect x="0" y="112" width="24" height="8" fill=',_color2,'/>',
                '<rect x="24" y="112" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="112" width="24" height="8" fill=',_color3,'/>',
                '<rect x="56" y="112" width="16" height="8" fill=',_color1,'/>',
                '<rect x="72" y="112" width="24" height="8" fill=',_color3,'/>',
                '<rect x="96" y="112" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="112" width="24" height="8" fill=',_color2,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="8" y="120" width="24" height="8" fill=',_color2,'/>',
                '<rect x="32" y="120" width="24" height="8" fill=',_color1,'/>',
                '<rect x="56" y="120" width="16" height="8" fill=',_color2,'/>',
                '<rect x="72" y="120" width="24" height="8" fill=',_color1,'/>',
                '<rect x="96" y="120" width="24" height="8" fill=',_color2,'/>',
                '<style>.base { fill: white; font-family: serif; font-size: 24px; }</style>',
                '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', 'Level:',_levels,'</text>',
                '</svg>'
            ));
        }


        bytes memory svg = abi.encodePacked(result);
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }
}


contract TPCGen3 is ERC1155URIStorage  {

    using SafeMath for *;
    using Strings for uint256;
    using Counters for Counters.Counter;
    using TPCGen3_Image1 for *;
    using TPCGen3_Image2 for *;
    using TPCGen3_ColorLib for *;
    Counters.Counter private _tokenIds;

     // Contract name
    string public name = "TrashPandazClub Gen3";
    // Contract symbol
    string public symbol = "TPCGEN3";

    mapping(uint256 => uint256) public tokenIdToLevel;
    mapping(uint256 => string) public tokenIdToChromosome;
    mapping(uint256 => string) public tokenIdToColor1; //dark
    mapping(uint256 => string) public tokenIdToColor2;
    mapping(uint256 => string) public tokenIdToColor3;
    mapping(uint256 => string) public tokenIdToColor4;
    mapping(uint256 => string) public tokenIdToColor5; //light
    mapping(uint256 => string) public tokenIdToRarity;


    // Rarity percentages
    uint public commonPercent = 60;
    uint public rarePercent = 32;
    uint public epicPercent = 8;

    //track levels
    //track hp
    //track strength
    //track speed


    constructor() ERC1155("")  {}

    function getRarity(uint256 tokenId) public view returns (string memory) {
        string memory rarity = tokenIdToRarity[tokenId];
        return rarity;
    }
    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToLevel[tokenId];
        return level.toString();
    }
    function getChromosome(uint256 tokenId) public view returns (string memory) {
        string memory chromosome = tokenIdToChromosome[tokenId];
        return chromosome;
    }

    function generateCharacter(uint _tokenId) public view returns (string memory){
        string memory _color1 = tokenIdToColor1[_tokenId];
        string memory _color2 = tokenIdToColor2[_tokenId];
        string memory _color3 = tokenIdToColor3[_tokenId];
        string memory _color4 = tokenIdToColor4[_tokenId];
        string memory _color5 = tokenIdToColor5[_tokenId];
        string memory _level = getLevel(_tokenId);
        string memory _chromosome = getChromosome(_tokenId);
        string memory _result = TPCGen3_Image1.generateCharacter(_color1,_color2,_color3,_color4,_color5);
        string memory _finalImage = TPCGen3_Image2.generateCharacter(_result, _color1,_color2,_color3,_color4,_color5,_level,_chromosome);
        return _finalImage;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "TPCGen3 #', tokenId.toString(), '",',
                '"description": "TrashPandazClub Gen3",',
                '"image": "', generateCharacter(tokenId), '",',
                '"attributes": [{"trait_type": "Rarity", "value": "',getRarity(tokenId),'"},{"trait_type": "Chromosome", "value": "',getChromosome(tokenId),'"},{"trait_type": "Color 1", "value": ',tokenIdToColor1[tokenId],'},{"trait_type": "Color 2", "value": ',tokenIdToColor2[tokenId],'},{"trait_type": "Color 3", "value": ',tokenIdToColor3[tokenId],'},{"trait_type": "Color 4", "value": ',tokenIdToColor4[tokenId],'},{"trait_type": "Color 5", "value": ',tokenIdToColor5[tokenId],'},{"trait_type": "Level", "display_type": "number", "value": "',getLevel(tokenId),'"}]',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    event RarityAttempt(string tokenRarity);

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        
        // give birth
        tokenIdToLevel[newItemId] = 0;
        string memory _chrome = generateChromosome(msg.sender);
        tokenIdToChromosome[newItemId] = _chrome;
        // generate rarity
        string memory _rarity = generateRarity(msg.sender);
        tokenIdToRarity[newItemId] = _rarity;
        emit RarityAttempt(tokenIdToRarity[newItemId]);
        // pick color groups based on rarity
        generateColorByRarity(msg.sender, tokenIdToRarity[newItemId], newItemId);

        _mint(msg.sender, newItemId, 1, "");
        _setURI(newItemId, getTokenURI(newItemId));
    }

    function generateChromosome(address _creator) private view returns(string memory){
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, _creator))) % 2;
        string memory _chrome = "";
        // Return true if the random number is 1, false otherwise
        if(randomNumber == 1) {
            _chrome = "XX";
            return _chrome;
        } else {
            _chrome = "XY";
            return _chrome;
        }
    }

    function generateRarity(address _creator) private view returns(string memory){
         uint roll = uint(keccak256(abi.encodePacked(block.timestamp, _creator))) % 100;
         string memory _roll ="";
        if (roll < commonPercent) {
            _roll = "common";
            return _roll;
        } else if (roll < commonPercent + rarePercent) {
            _roll = "rare";
            return _roll;
        } else {
            _roll="epic";
            return _roll;
        } 
    }

    function generateColorByRarity(address _creator, string memory _rarity, uint _tokenId) private{
        string[4][5] memory colors;
        if(keccak256(abi.encodePacked(_rarity)) == keccak256(abi.encodePacked("common"))){
            colors = TPCGen3_ColorLib.getColorsCommon();
        }
        if (keccak256(abi.encodePacked(_rarity)) == keccak256(abi.encodePacked("rare"))){
            colors = TPCGen3_ColorLib.getColorsRare();
        }
        if (keccak256(abi.encodePacked(_rarity)) == keccak256(abi.encodePacked("epic"))){
            colors = TPCGen3_ColorLib.getColorsEpic();
        }

        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, _creator,  uint(0))));
        uint randomIndex2 = uint(keccak256(abi.encodePacked(block.timestamp, _creator, uint(1))));
        uint randomIndex3 = uint(keccak256(abi.encodePacked(block.timestamp, _creator, uint(2))));
        uint randomIndex4 = uint(keccak256(abi.encodePacked(block.timestamp, _creator, uint(3))));
        uint randomIndex5 = uint(keccak256(abi.encodePacked(block.timestamp, _creator, uint(4))));
        // Use the random index to select a color from the array
        tokenIdToColor1[_tokenId] = colors[0][randomIndex % colors[0].length];
        tokenIdToColor2[_tokenId] = colors[1][randomIndex2 % colors[0].length];
        tokenIdToColor3[_tokenId] = colors[2][randomIndex3 % colors[0].length];
        tokenIdToColor4[_tokenId] = colors[3][randomIndex4 % colors[0].length];
        tokenIdToColor5[_tokenId] = colors[4][randomIndex5 % colors[0].length];
    }

    function train(uint256 tokenId) public {
        require(balanceOf(msg.sender,tokenId) == 1, "You must own this NFT to train it!");
        uint256 currentLevel = tokenIdToLevel[tokenId];
        tokenIdToLevel[tokenId] = currentLevel + 1;
        _setURI(tokenId, getTokenURI(tokenId));
    }

}

    

