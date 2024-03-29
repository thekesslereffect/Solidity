// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IGen3Image{
    function getImage(string[4] memory _color, string memory _chromosome, bool _mutated) external view returns(string memory);
}

interface IGen3Attributes{
    function getExtraAttributes(uint _seed) external view returns(string memory);
    function getColor(uint _seed) external view returns(string[4] memory);
    function getMutationColor(uint _seed) external view returns(string[4] memory);
    function getChromosome(uint _seed) external view returns(string memory);
    function getElemental(uint _seed) external view returns(string memory);
}

contract Gen3Token is ERC1155URIStorage, AccessControl{
    using SafeMath for *;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;

    string public name = "TrashPandazClub Gen3";
    string public symbol = "TPCGEN3";
    // string public description = "Get ready for the TrashPandazClub Gen3 NFT collection, an exciting world of pixel art that will leave you wanting more! Hurry to trashpandazclub.com and mint your own one-of-a-kind TrashPandaz with exclusive mutations, eye-catching patterns, and vibrant color palettes. Dont miss out on this fantastic opportunity to join the hype, elevate your NFT collection, and become an integral part of the ever-growing TrashPandazClub community!";
    string public imageURI = "QmX2SiSVtSWLemBcpQLi4iUWAkhq3XZ39RstX3zr8inFGB";
    string[] private imageColors = ["brown.svg","red.svg","green.svg","pink.svg","orange.svg","black.svg","yellow.svg","blue.svg","purple.svg"];

    address gen3_ImageContract;
    address gen3_AttributesContract;

    struct Token{
        string image;
        uint birthday;
        bool hatched;
        uint seed;
        string[4] color;
        string chromosome;
        string elemental;
        bool mutated;
    }
    mapping(uint256 => Token) public tokens;
    
    uint public incubationTime;

    bytes32 public constant CONTROLLER_ROLE = keccak256("CONTROLLER_ROLE");

    constructor(address _gen3_ImageContract, address _gen3_AttributesContract) ERC1155("")  {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CONTROLLER_ROLE, msg.sender);
        incubationTime = 5 days;
        gen3_ImageContract = _gen3_ImageContract;
        gen3_AttributesContract = _gen3_AttributesContract;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            _tokenURIPrefix(_tokenId),
            _tokenURIPayload(_tokenId)
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function _tokenURIPrefix(uint256 _tokenId) private view returns (string memory) {
        return string(
                abi.encodePacked(
                    '{ "name": "TPCGen3 #',_tokenId.toString(),
                    '", "description": "Gen3!", "image": "',
                    tokens[_tokenId].image,
                    '",' 
                ));
    }

    function _tokenURIPayload(uint256 _tokenId) private view returns (string memory) {
        if (tokens[_tokenId].hatched == false) {
            string memory _rarity = (uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % 100) < 50 ? "common" : (uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % 100) < 75 ? "rare" : "legendary";
            return string(
                abi.encodePacked(
                    '"attributes": [{"trait_type": "Incubation","max_value": 100, "value": ',
                    getIncubationProgress(_tokenId).toString(),
                    '},{"trait_type": "Rarity", "value": "',
                    _rarity,
                    '"}',
                    ']}'
                )
            );
        } else {
            string[4] memory _color = tokens[_tokenId].color;
            string memory result;
            string memory extraAttributes = IGen3Attributes(gen3_AttributesContract).getExtraAttributes(tokens[_tokenId].seed);
            string memory mutation = tokens[_tokenId].mutated == true?'{"trait_type": "Mutated", "value": "Mutated"},' : "";
            result = string(
                abi.encodePacked(
                    '"attributes": [',
                    '{"trait_type": "Elemental", "value": "',
                    tokens[_tokenId].elemental,
                    '"},{"trait_type": "Chromosome", "value": "',
                    tokens[_tokenId].chromosome,
                    '"},',
                    mutation,                    
                    '{"trait_type": "Color 1", "value": "',
                    _color[0],
                    '"},{"trait_type": "Color 2", "value": "',
                    _color[1]));
            result = string(abi.encodePacked(
                result,
                '"},{"trait_type": "Color 3", "value": "',
                _color[2],
                '"},{"trait_type": "Color 4", "value": "',
                _color[3],
                '"}',
                extraAttributes,
                ']}'
            ));
            return result;
        }
            
        
    }

    function getIncubationProgress(uint _tokenId) public view returns(uint) {
        uint elapsedTime = block.timestamp - tokens[_tokenId].birthday;
        uint progress = elapsedTime * 100 / incubationTime;
        if(progress>100){
            progress = 100;
        }
        return progress;
    }

    function hatch(address _address, uint _tokenId) external onlyRole(CONTROLLER_ROLE){
        if(hasRole(DEFAULT_ADMIN_ROLE, _address) == false){
            require(getIncubationProgress(_tokenId) == 100, "It's not ready yet...");
        }
        require(balanceOf(_address,_tokenId) >= 1, "You aren't the owner!");
        require(tokens[_tokenId].hatched==false, "That one is hatched already...");
        tokens[_tokenId].hatched = true;
        if(keccak256(abi.encode(tokens[_tokenId].elemental)) == keccak256(abi.encode("collab"))){
            string memory chromosome = uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % 2 == 1 ? "XX" : "XY" ;
            string memory image = IGen3Image(gen3_ImageContract).getImage(tokens[_tokenId].color, chromosome, tokens[_tokenId].mutated);
            tokens[_tokenId].image = image;
        }else if(tokens[_tokenId].mutated == true){
            string memory image = IGen3Image(gen3_ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated);
            tokens[_tokenId].image = image;
        }else{
            string[4] memory color = IGen3Attributes(gen3_AttributesContract).getColor(tokens[_tokenId].seed);
            tokens[_tokenId].color = color;
            string memory elemental = IGen3Attributes(gen3_AttributesContract).getElemental(tokens[_tokenId].seed);
            tokens[_tokenId].elemental = elemental;
            string memory chromosome = IGen3Attributes(gen3_AttributesContract).getChromosome(tokens[_tokenId].seed);
            tokens[_tokenId].chromosome = chromosome;
            string memory image = IGen3Image(gen3_ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated );
            tokens[_tokenId].image = image;
        }
    }

    function customColorForUnknown(address _address, uint _tokenId, string[4] memory _colors) external onlyRole(CONTROLLER_ROLE){
        require(balanceOf(_address,_tokenId) == 1, "You aren't the owner!");
        string memory _elemental = IGen3Attributes(gen3_AttributesContract).getElemental(tokens[_tokenId].seed);
        require(keccak256(abi.encode(_elemental)) == keccak256((abi.encode("unknown"))), "Only Unknown TrashPandaz can be customized");
        tokens[_tokenId].color = _colors;
        string memory image = IGen3Image(gen3_ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated );
        tokens[_tokenId].image = image;
    }

    function mutate(address _address, uint _tokenId) external onlyRole(CONTROLLER_ROLE){
        require(tokens[_tokenId].mutated==false,"This NFT has already has mutated DNA.");
        require(keccak256(abi.encode(tokens[_tokenId].elemental)) != keccak256(abi.encode("collab")),"Collab NFTs cannot be mutated.");
        require(balanceOf(_address,_tokenId) == 1, "You aren't the owner!");
        tokens[_tokenId].mutated=true;
        string[4] memory color = IGen3Attributes(gen3_AttributesContract).getMutationColor(tokens[_tokenId].seed);
        tokens[_tokenId].color = color;
        if(tokens[_tokenId].hatched == true){
            tokens[_tokenId].image = IGen3Image(gen3_ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated );
        }
    }

    function mint(address _address) external onlyRole(CONTROLLER_ROLE){
        _tokenIds.increment();
        uint256 _newItemId = _tokenIds.current();
        mintStats(_newItemId);
        _mint(_address, _newItemId, 1, ""); 
    }

    function mintStats(uint _newItemId) private {
        Token memory newToken = Token({
            image: "",
            birthday: block.timestamp,
            hatched: false,
            color: ["???","???","???","???"],
            chromosome: "???",
            elemental: "???",
            seed: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId))),
            mutated: false
        });
        tokens[_newItemId] = newToken;
        // create egg image
        string memory _rarity = (uint256(keccak256(abi.encode(tokens[_newItemId].seed))) % 100) < 50 ? "common" : (uint256(keccak256(abi.encode(tokens[_newItemId].seed))) % 100) < 80 ? "rare" : "legendary";
        string memory _color = imageColors[uint256(keccak256(abi.encode(tokens[_newItemId].seed))) % imageColors.length];
        tokens[_newItemId].image = string(abi.encodePacked("ipfs://",imageURI,"/",_rarity,"_",_color));
    }

    function mintCollab(address _address, string memory _projectName, string[4] memory _colors) external onlyRole(CONTROLLER_ROLE){
        _tokenIds.increment();
        uint256 _newItemId = _tokenIds.current();
        mintStatsCollab(_newItemId,_projectName,_colors);
        _mint(_address, _newItemId, 1, ""); 
    }

    function mintStatsCollab(uint _newItemId, string memory _projectName, string[4] memory _colors) private {
        Token memory newToken = Token({
            image: string(abi.encodePacked("ipfs://",imageURI,"/","collab_collab.svg")),
            elemental: "collab",
            chromosome: _projectName,
            birthday: block.timestamp,
            hatched: false,
            color: _colors,
            seed: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId))),
            mutated: false
        });
        tokens[_newItemId] = newToken;
    }

    function setIncubationTime(uint _time) public onlyRole(DEFAULT_ADMIN_ROLE){
        incubationTime = _time;
    }

    // function setImageURI(string memory _imageURI) public onlyRole(DEFAULT_ADMIN_ROLE){
    //     imageURI = _imageURI;
    // }

    // function setImageColors(string[] memory _imageColors)public onlyRole(DEFAULT_ADMIN_ROLE){
    //     imageColors = _imageColors;
    // }

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

    function getTokenImagesOfOwner(address _address) public view returns(string[] memory){
        uint[] memory _tokens = getTokensOfOwner(_address);
        string[] memory _images = new string[](_tokens.length);
        for(uint i=0; i<_tokens.length;i++){
            _images[i] = tokens[_tokens[i]].image;
        }
        return _images;
    }

    // function getTokenColors(uint[] memory _tokenId) public view returns(string[][] memory){
    //     string[][] memory _colors = new string[][](_tokenId.length);
    //     for(uint i=0; i<_tokenId.length;i++){
    //         string[4] memory tokenColors = tokens[_tokenId[i]].color;
    //         _colors[i] = new string[](tokenColors.length);
    //         for (uint j = 0; j < tokenColors.length; j++) {
    //             _colors[i][j] = tokenColors[j];
    //         }
    //     }
    //     return _colors;
    // }

    function setIGen3ImageContract(address _gen3_ImageContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3_ImageContract = _gen3_ImageContract;
    }

    function setIGen3AttributesContract(address _gen3_AttributesContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3_AttributesContract = _gen3_AttributesContract;
    }

    // function setDescription(string memory _description) public onlyRole(DEFAULT_ADMIN_ROLE){
    //     description = _description;
    // }

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