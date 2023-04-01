// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.18;

// import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/utils/Base64.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/access/AccessControl.sol";

// contract gen3_Token is ERC1155{
//     // This is hard data. Only include things you dont want to change in the future
//     // mint token id to owner
//     // token id => seedom seed
//     // token id => birthday
//     // token id => owner
//     // token id => hatched
//     // token id => rare/legendary
//     // token id => colors[]
//     // create metadata from other contacts
// }


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";



contract Gen3_Image{
    function getImage(uint _seed) public returns(string memory) {}
}

contract Gen3_Attributes{
    function getAttributes(uint _seed) public returns(string memory){}
}


contract Gen3_Token is ERC1155URIStorage, AccessControl{
    using SafeMath for *;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;

    string public name = "TrashPandazClub Gen3";
    string public symbol = "TPCGEN3";
    string public description = "Get ready for the TrashPandazClub Gen3 NFT collection, an exciting world of pixel art that will leave you wanting more! Hurry to trashpandazclub.com and mint your own one-of-a-kind TrashPandaz with exclusive mutations, eye-catching patterns, and vibrant color palettes. Dont miss out on this fantastic opportunity to join the hype, elevate your NFT collection, and become an integral part of the ever-growing TrashPandazClub community!";
    string public imageURI = "QmX2SiSVtSWLemBcpQLi4iUWAkhq3XZ39RstX3zr8inFGB";
    string[] private imageColors = ["brown.svg","red.svg","green.svg","pink.svg","orange.svg","black.svg","yellow.svg","blue.svg","purple.svg"];

    address gen3_ImageContract;
    address gen3_AttributeContract;

    struct Token{
        string image;
        uint birthday;
        bool hatched;
        uint seed;
    }
    mapping(uint256 => Token) public tokens;


    bool public hatchingPaused;
    uint public incubationTime;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant MUTATION_ROLE = keccak256("MUTATION_ROLE");

    constructor(address _gen3_ImageContract, address _gen3_AttributesContract) ERC1155("")  {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MUTATION_ROLE, msg.sender);
        hatchingPaused = true;
        incubationTime = 2 days;
        gen3_ImageContract = _gen3_ImageContract;
        gen3_AttributesContract = _gen3_AttributesContract;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            _tokenURIPrefix(tokenId),
            _tokenURIPayload(tokenId),
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
                    ),'",' 
                );
    }

    function _tokenURIPayload(uint256 tokenId) private view returns (string memory) {
        if (tokens[tokenId].hatched == false) {
            return string(
                abi.encodePacked(
                    '"attributes": [{"trait_type": "Incubation","max_value": 100, "value": ',
                    getIncubationProgress(tokenId).toString(),
                    '}]',
                    '}'
                )
            );
        } else {
            return string(
                abi.encodePacked(
                    Gen3_Attributes(gen3_AttributeContract).getAttributes(tokens[tokenId].seed),
                    '}'
            );
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

    function hatch(uint _tokenId) public{
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) == false){
            require(hatchingPaused == false,"Hatching is paused at the moment. Check back later.");
            require(getIncubationProgress(_tokenId) == 100, "It's not ready yet...");
        }
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        require(tokens[_tokenId].hatched==false, "That one is hatched already...");

        tokens[_tokenId].hatched = true;
        string memory elemental = Gen3_Attributes(gen3_AttributesContract).getElemental(tokens[_tokenId].seed);
        tokens[_tokenId].color = Gen3_Attributes(gen3_AttributesContract).getColor(tokens[_tokenId].seed, elemental);
        tokens[_tokenId].image = Gen3_Image(gen3_ImageContract).getImage(tokens[_tokenId].seed, elemental);
    }

    function customColorForUnknown(uint _tokenId, string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5) public {
        require(balanceOf(msg.sender,_tokenId) == 1, "You aren't the owner!");
        require(keccak256(abi.encodePacked(tokens[_tokenId].elemental)) == keccak256((abi.encodePacked("unknown"))), "Only Unknown TrashPandaz can be customized");
        string[5] memory color;
        color[0] = string(abi.encodePacked('"',_color1,'"'));
        color[1] = string(abi.encodePacked('"',_color2,'"'));
        color[2] = string(abi.encodePacked('"',_color3,'"'));
        color[3] = string(abi.encodePacked('"',_color4,'"'));
        color[4] = string(abi.encodePacked('"',_color5,'"'));
        tokens[_tokenId].color = color;
        tokens[_tokenId].image = Gen3_Image(gen3_ImageContract).getImageCustomColor(tokens[_tokenId].seed, color);
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
            birthday: block.timestamp,
            hatched: false,
            color: ["???","???","???","???","???"],
            seed: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId))),
        });
        tokens[_newItemId] = newToken;
        // create egg image
        _style = (tokens[_newItemId].seed % 100) < 50 ? "common" : (tokens[_newItemId].seed % 100) < 75 ? "rare" : "legendary";
        string memory _color = imageColors[tokens[_newItemId].seed % imageColors.length];
        tokens[_newItemId].image = string(abi.encodePacked("ipfs://",imageURI,"/",_style,"_",_color));
    }

    // function mintCollab(address _minter, string memory _projectName, string[5] memory _colors) public onlyRole(DEFAULT_ADMIN_ROLE){
    //     _tokenIds.increment();
    //     uint256 _newItemId = _tokenIds.current();
    //     mintStatsCollab(_newItemId,_projectName,_colors);
    //     _mint(_minter, _newItemId, 1, ""); 
    // }

    // function mintStatsCollab(uint _newItemId, string memory _projectName, string[5] memory _colors) private {
    //     string[5] memory _colorsArray;
    //     _colorsArray[0] = string(abi.encodePacked('"',_colors[0],'"'));
    //     _colorsArray[1] = string(abi.encodePacked('"',_colors[1],'"'));
    //     _colorsArray[2] = string(abi.encodePacked('"',_colors[2],'"'));
    //     _colorsArray[3] = string(abi.encodePacked('"',_colors[3],'"'));
    //     _colorsArray[4] = string(abi.encodePacked('"',_colors[4],'"'));
    //     Token memory newToken = Token({
    //         image: string(abi.encodePacked("ipfs://",imageURI,"/","collab_collab.svg")),
    //         elemental: "collab",
    //         chromosome: _projectName,
    //         birthday: block.timestamp,
    //         hatched: false,
    //         color: _colorsArray,
    //         seed: uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _newItemId))),
    //     });
    //     tokens[_newItemId] = newToken;
    // }

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

    function setGen3_ImageContract(address _gen3_ImageContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3_ImageContract = _gen3_ImageContract;
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

