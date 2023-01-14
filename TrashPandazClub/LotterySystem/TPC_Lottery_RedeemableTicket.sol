pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC1155.sol";

contract TPC_Lottery_RedeemableTicket is ERC1155 {
    mapping(uint256 => uint8) public rarity;
    mapping(uint256 => string) public imageURI;

    function mint(address _to, uint256[] _ids, uint256[] _values, uint8[] _rarities, string[] _imageURIs) public {
        require(_ids.length == _values.length && _ids.length == _rarities.length && _ids.length == _imageURIs.length, "Lengths must match");
        super._mint(_to, _ids, _values);
        for (uint256 i = 0; i < _ids.length; i++) {
            rarity[_ids[i]] = _rarities[i];
            imageURI[_ids[i]] = _imageURIs[i];
        }
    }

    function getImageURI(uint256 _id) public view returns (string memory) {
        return imageURI[_id];
    }

    function getRarity(uint256 _id) public view returns (uint8) {
        return rarity[_id];
    }
}
