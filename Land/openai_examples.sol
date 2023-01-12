pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";

// Land NFT with coordinate inputs and ability to set name and transfer ownership
contract Land {
    address public owner;
    uint public xCoordinate;
    uint public yCoordinate;
    string public name;
    address payable public marketplace;
    bool public forSale;
    uint256 public price;
    address public tokenAddress;
    mapping(address => uint256) public balanceOf;

    constructor() public {
        owner = msg.sender;
    }

    function setCoordinates(uint _xCoordinate, uint _yCoordinate) public {
        require(_xCoordinate >= 0 && _xCoordinate <= 9, "Invalid x coordinate");
        require(_yCoordinate >= 0 && _yCoordinate <= 9, "Invalid y coordinate");
        xCoordinate = _xCoordinate;
        yCoordinate = _yCoordinate;
    }

    function setName(string memory _name) public {
        name = _name;
    }

    function setMarketplace(address payable _marketplace) public {
        require(msg.sender == owner, "Only the owner can set the marketplace address");
        marketplace = _marketplace;
    }

    function setForSale(bool _forSale) public {
        require(msg.sender == owner, "Only the owner can put the land up for sale");
        forSale = _forSale;
    }

    function setPrice(uint256 _price) public {
        require(msg.sender == owner, "Only the owner can set the sale price");
        price = _price;
    }

    function setToken(address _tokenAddress) public {
        require(msg.sender == marketplace, "Only the marketplace can set the token address");
        tokenAddress = _tokenAddress;
    }

    function approve(address spender, uint256 value) public {
        require(msg.sender == owner, "Only the owner can approve token transfer");
        require(balanceOf[msg.sender] >= value && value > 0, "Insufficient tokens");
        require(address(this).balance >= value, "Insufficient ETH balance");
        require(tokenAddress.transferFrom(msg.sender, spender, value), "Transfer failed");
        balanceOf[msg.sender] -= value;
    }

    function buyLand() public payable {
        require(forSale == true, "Land is not for sale");
        require(msg.value == price, "Incorrect purchase price");
        require(address(tokenAddress).transfer(owner, msg.value), "Token transfer failed");
        balanceOf[msg.sender] += msg.value;
        owner = msg.sender;
        forSale = false;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only the current owner can transfer ownership");
        owner = newOwner;
    }
}

//Overworld style 

pragma solidity ^0.8.0;

contract Overworld {
    address[10][10] public land;
    mapping(address => uint) public landIds;
    bool[10][10] public landTaken;
    address[10][10] public landOwners;

    function setLand(uint x, uint y, address landAddress, uint id, address owner) public {
        require(x < 10 && y < 10);
        require(land[x][y] == address(0));
        land[x][y] = landAddress;
        landIds[landAddress] = id;
        landOwners[x][y] = owner;
        landTaken[x][y] = true;
    }

    function removeLand(uint x, uint y) public {
        require(x < 10 && y < 10);
        require(land[x][y] != address(0));
        landIds[land[x][y]] = 0;
        landOwners[x][y] = address(0);
        land[x][y] = address(0);
        landTaken[x][y] = false;
    }

    function getLandOwner(uint x, uint y) public view returns (address owner) {
        require(x < 10 && y < 10);
        owner = landOwners[x][y];
    }
}

pragma solidity ^0.8.0;

import "https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md";

contract Overworld is ERC1155 {
    mapping(uint => address) public land;
    mapping(address => uint) public landIds;
    mapping(address => mapping(uint => bool)) public landOwnership;

    function setLand(uint id, address landAddress, address owner) public {
        require(land[id] == address(0));
        land[id] = landAddress;
        landIds[landAddress] = id;
        landOwnership[owner][id] = true;
        _mint(owner, id, 1);
    }

    function removeLand(uint id, address owner) public {
        require(land[id] != address(0));
        require(landOwnership[owner][id] == true);
        landIds[land[id]] = 0;
        land[id] = address(0);
        landOwnership[owner][id] = false;
        _burn(owner, id, 1);
    }

    function getLand(uint id) public view returns (address landAddress) {
        landAddress = land[id];
    }

    function getLandOwner(uint id) public view returns (address owner) {
        for (address a in landOwnership) {
            if (landOwnership[a][id] == true) {
                owner = a;
                return;
            }
        }
    }

    function isLandOwner(address owner, uint id) public view returns (bool) {
        return landOwnership[owner][id];
    }
}