// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

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

contract Gen3Token is ERC1155URIStorage{
    using SafeMath for *;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;

    string public name = "TrashPandazClub Gen3";
    string public symbol = "TPCGEN3";
    string private imageURI;
    string[] private imageColors;

    address gen3ImageContract;
    address gen3AttributesContract;

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
    
    uint private incubationTime;
    mapping (address => bool) controller;
    address private owner;

    constructor(address _gen3ImageContract, address _gen3AttributesContract) ERC1155("")  {
        incubationTime = 5 days;
        gen3ImageContract = _gen3ImageContract;
        gen3AttributesContract = _gen3AttributesContract;
        owner = msg.sender;
        controller[msg.sender] = true;
        imageURI = "QmX2SiSVtSWLemBcpQLi4iUWAkhq3XZ39RstX3zr8inFGB";
        imageColors = ["brown.svg","red.svg","green.svg","pink.svg","orange.svg","black.svg","yellow.svg","blue.svg","purple.svg"];
    }

    function _onlyController() private view { 
        require(controller[msg.sender] == true);
    }
    modifier onlyController(){
        _onlyController();
        _;
    }
    function setController(address _controller, bool _enable) public onlyOwner{
        controller[_controller] = _enable;
    }
    function _onlyOwner() private view{
        require(msg.sender == owner);
    }
    modifier onlyOwner{
        _onlyOwner();
        _;
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
            string memory extraAttributes = IGen3Attributes(gen3AttributesContract).getExtraAttributes(tokens[_tokenId].seed);
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

    function hatch(address _address, uint _tokenId) external onlyController{
        require(getIncubationProgress(_tokenId) == 100);
        require(balanceOf(_address,_tokenId) >= 1);
        require(tokens[_tokenId].hatched==false);
        tokens[_tokenId].hatched = true;
        if(keccak256(abi.encode(tokens[_tokenId].elemental)) == keccak256(abi.encode("collab"))){
            string memory chromosome = uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % 2 == 1 ? "XX" : "XY" ;
            string memory image = IGen3Image(gen3ImageContract).getImage(tokens[_tokenId].color, chromosome, tokens[_tokenId].mutated);
            tokens[_tokenId].image = image;
        }else if(tokens[_tokenId].mutated == true){
            string memory image = IGen3Image(gen3ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated);
            tokens[_tokenId].image = image;
        }else{
            string[4] memory color = IGen3Attributes(gen3AttributesContract).getColor(tokens[_tokenId].seed);
            tokens[_tokenId].color = color;
            string memory elemental = IGen3Attributes(gen3AttributesContract).getElemental(tokens[_tokenId].seed);
            tokens[_tokenId].elemental = elemental;
            string memory chromosome = IGen3Attributes(gen3AttributesContract).getChromosome(tokens[_tokenId].seed);
            tokens[_tokenId].chromosome = chromosome;
            string memory image = IGen3Image(gen3ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated );
            tokens[_tokenId].image = image;
        }
    }

    function customColorForUnknown(address _address, uint _tokenId, string[4] memory _colors) external onlyController{
        require(balanceOf(_address,_tokenId) == 1);
        string memory _elemental = IGen3Attributes(gen3AttributesContract).getElemental(tokens[_tokenId].seed);
        require(keccak256(abi.encode(_elemental)) == keccak256((abi.encode("unknown"))));
        tokens[_tokenId].color = _colors;
        string memory image = IGen3Image(gen3ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated );
        tokens[_tokenId].image = image;
    }

    function mutate(address _address, uint _tokenId) external onlyController{
        require(tokens[_tokenId].mutated==false);
        require(keccak256(abi.encode(tokens[_tokenId].elemental)) != keccak256(abi.encode("collab")));
        require(balanceOf(_address,_tokenId) == 1);
        tokens[_tokenId].mutated=true;
        string[4] memory color = IGen3Attributes(gen3AttributesContract).getMutationColor(tokens[_tokenId].seed);
        tokens[_tokenId].color = color;
        if(tokens[_tokenId].hatched == true){
            tokens[_tokenId].image = IGen3Image(gen3ImageContract).getImage(tokens[_tokenId].color, tokens[_tokenId].chromosome, tokens[_tokenId].mutated );
        }
    }

    function mint(address _address) external onlyController{
        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();
        mintStats(_tokenId);
        _mint(_address, _tokenId, 1, ""); 
    }

    function mintStats(uint _tokenId) private {
        Token memory newToken = Token({
            image: "",
            birthday: block.timestamp,
            hatched: false,
            color: ["???","???","???","???"],
            chromosome: "???",
            elemental: "???",
            seed: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _tokenId))),
            mutated: false
        });
        tokens[_tokenId] = newToken;
        // create egg image
        string memory _rarity = (uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % 100) < 50 ? "common" : (uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % 100) < 80 ? "rare" : "legendary";
        string memory _color = imageColors[uint256(keccak256(abi.encode(tokens[_tokenId].seed))) % imageColors.length];
        tokens[_tokenId].image = string(abi.encodePacked("ipfs://",imageURI,"/",_rarity,"_",_color));
    }

    function mintCollab(address _address, string memory _projectName, string[4] memory _colors) external onlyOwner{
        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();
        Token memory newToken = Token({
            image: string(abi.encodePacked("ipfs://",imageURI,"/","collab_collab.svg")),
            elemental: "collab",
            chromosome: _projectName,
            birthday: block.timestamp,
            hatched: false,
            color: _colors,
            seed: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _tokenId))),
            mutated: false
        });
        tokens[_tokenId] = newToken;
        _mint(_address, _tokenId, 1, ""); 
    }

    function getTokensOfOwner(address _address) public view returns(uint[] memory){
        uint[] memory _tokens = new uint[](_tokenIds.current());
        uint _count = 0;
        for (uint i=0; i<_tokenIds.current(); i++) 
        {
            if(balanceOf(_address, i+1)>0){
                _tokens[_count] = i+1; 
                _count++;
            }
        }
        return _tokens;
    }

    // ADMIN
    function setContracts(address _gen3ImageContract, address _gen3AttributesContract) public onlyOwner{
        gen3ImageContract = _gen3ImageContract;
        gen3AttributesContract = _gen3AttributesContract;
    }
    function setImageURI(string memory _imageURI) public onlyOwner{
        imageURI = _imageURI;
    }
    function setIncubationTime(uint _time) public onlyOwner{
        incubationTime = _time;
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}