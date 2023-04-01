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

library TPCGen3_Image1 {

    function generateCharacter(string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5 ) public pure returns(string memory){


        // stack too deep so we need to split this bitch up
        string memory result = "";
        {
            result = string(abi.encodePacked(
                '<svg width="128" height="128" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://boxy-svg.com" shape-rendering="crispEdges">',
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
    function generateCharacter(string memory _result, string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5, string memory _chromosome ) public pure returns(string memory){
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
                // '<rect x="0" y="80" width="8" height="8" fill=',_color2,'/>',
              '<rect x="8" y="80" width="8" height="8" fill=',_color1,'/>',
                '<rect x="16" y="80" width="96" height="8" fill=',_color5,'/>',
                '<rect x="112" y="80" width="8" height="8" fill=',_color1,'/>'
                // '<rect x="120" y="80" width="8" height="8" fill=',_color2,'/>'
                
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
                // '<rect x="0" y="112" width="24" height="8" fill=',_color2,'/>',
                '<rect x="0" y="112" width="24" height="8" fill="#0000006B"/>',
                '<rect x="24" y="112" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="112" width="24" height="8" fill=',_color3,'/>',
                '<rect x="56" y="112" width="16" height="8" fill=',_color1,'/>',
                '<rect x="72" y="112" width="24" height="8" fill=',_color3,'/>',
                '<rect x="96" y="112" width="8" height="8" fill=',_color1,'/>',
                // '<rect x="104" y="112" width="24" height="8" fill=',_color2,'/>'
                '<rect x="104" y="112" width="24" height="8" fill="#0000006B"/>'

            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                // '<rect x="8" y="120" width="24" height="8" fill=',_color2,'/>',
                '<rect x="8" y="120" width="24" height="8" fill="#0000006B"/>',
                '<rect x="32" y="120" width="24" height="8" fill=',_color1,'/>',
                // '<rect x="56" y="120" width="16" height="8" fill=',_color2,'/>',
                '<rect x="56" y="120" width="16" height="8" fill="#0000006B"/>',
                '<rect x="72" y="120" width="24" height="8" fill=',_color1,'/>',
                // '<rect x="96" y="120" width="24" height="8" fill=',_color2,'/>',
                '<rect x="96" y="120" width="24" height="8" fill="#0000006B"/>',
                // '<style bx:fonts="Silkscreen">@import url(https://fonts.googleapis.com/css2?family=Silkscreen%3Aital%2Cwght%400%2C400%3B0%2C700&amp;display=swap);</style>',
                // '<text x="50%" y="50%" fill="rgb(0,0,0)" font-size="20px" font-family="Silkscreen" dominant-baseline="middle" text-anchor="middle">', 'Level:',_levels,'</text>',
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

contract Eggs is ERC1155URIStorage, AccessControl{
    using SafeMath for *;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;

     // Contract name & symbol
    string public name = "TrashPandazClub Gen3";
    string public symbol = "TPCGEN3";

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
        string[5] color;
        uint rand;
    }
    mapping(uint256 => Token) public tokens;
    mapping(string => string[4][5]) public rarityToColors;

    bool public hatchingPaused;
    uint public incubationTime;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC1155("")  {
        imageURI = "QmVBcVYSBZGzksdPBBw5bgiqacikZExjkR6MisWHEEDeof";
        imageColors = ["brown.svg","red.svg","green.svg","pink.svg","orange.svg","black.svg","yellow.svg","blue.svg","purple.svg"];
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        hatchingPaused = true;
        incubationTime = 5 days;
        rarityToColors["common"] = TPCGen3_ColorLib.getColorsCommon();
        rarityToColors["rare"] = TPCGen3_ColorLib.getColorsRare();
        rarityToColors["legendary"] = TPCGen3_ColorLib.getColorsLegendary();
    }

    function tokenURI(uint256 tokenId) public view returns (string memory){
        // add if statement to check if egg is hatched. If so then change the image and attributes to something else (just change all dataURI I guess)
        bytes memory dataURI;
        if(tokens[tokenId].hatched==false){
            dataURI = abi.encodePacked(
                '{',
                    '"name": "TPCGen3 #', tokenId.toString(), '",',
                    '"description": "TrashPandazClub Gen3",',
                    '"image": "', tokens[tokenId].image, '",',
                    '"attributes": [{"trait_type": "Rarity", "value": "',tokens[tokenId].rarity,'"},{"trait_type": "Incubation","max_value": 100, "value": ',getIncubationProgress(tokenId).toString(),'}]',
                '}'
            );
        }else{
            dataURI = abi.encodePacked(
                '{',
                    '"name": "TPCGen3 #', tokenId.toString(), '",',
                    '"description": "TrashPandazClub Gen3",',
                    '"image": "', tokens[tokenId].image, '",',
                    '"attributes": [{"trait_type": "Rarity", "value": "',tokens[tokenId].rarity,'"},{"trait_type": "Chromosome", "value": "',tokens[tokenId].chromosome,'"},{"trait_type": "Color 1", "value": ',tokens[tokenId].color[0],'},{"trait_type": "Color 2", "value": ',tokens[tokenId].color[1],'},{"trait_type": "Color 3", "value": ',tokens[tokenId].color[2],'},{"trait_type": "Color 4", "value": ',tokens[tokenId].color[3],'},{"trait_type": "Color 5", "value": ',tokens[tokenId].color[4],'}]',
                '}'
            );
        }
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
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
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) != true){
            require(hatchingPaused == true,"Hatching is paused at the moment. Check back later.");
            require(getIncubationProgress(_tokenId) == 100, "It's not ready yet...");
        }
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        require(tokens[_tokenId].hatched==false, "That one is hatched already...");
        tokens[_tokenId].hatched=true;
        //randomly pick colors and assign to token id then generate image string and assign to token id
        generateColorByRarity(tokens[_tokenId].rand,tokens[_tokenId].rarity,_tokenId);
        tokens[_tokenId].image = generateCharacter(_tokenId);
    }

    // USE THIS TO SET IMAGE
    function generateCharacter(uint _tokenId) public view returns (string memory){
        string memory _result = TPCGen3_Image1.generateCharacter(tokens[_tokenId].color[0],tokens[_tokenId].color[1],tokens[_tokenId].color[2],tokens[_tokenId].color[3],tokens[_tokenId].color[4]);
        string memory _finalImage = TPCGen3_Image2.generateCharacter(_result, tokens[_tokenId].color[0],tokens[_tokenId].color[1],tokens[_tokenId].color[2],tokens[_tokenId].color[3],tokens[_tokenId].color[4],tokens[_tokenId].chromosome);
        return _finalImage;
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
        tokens[_tokenId].color[0] = string.concat('"',_color1,'"');
        tokens[_tokenId].color[1] = string.concat('"',_color2,'"');
        tokens[_tokenId].color[2] = string.concat('"',_color3,'"');
        tokens[_tokenId].color[3] = string.concat('"',_color4,'"');
        tokens[_tokenId].color[4] = string.concat('"',_color5,'"');
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
            rand: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId)))
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
        string memory _color = imageColors[tokens[_newItemId].rand % imageColors.length]; // check this to make sure it gets the right random color
        tokens[_newItemId].image = string(abi.encodePacked("ipfs://",imageURI,"/",tokens[_newItemId].rarity,"_",_color));
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