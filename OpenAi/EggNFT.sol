pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract EggNFT is ERC721 {
  // The address of the NFT that the egg will hatch into
  address public hatchlingAddress;

  // The maximum number of eggs that can be minted
  uint256 public maxSupply;

  // The egg has not yet hatched
  bool public hatched = false;

  constructor(address _hatchlingAddress, uint256 _maxSupply) public {
    hatchlingAddress = _hatchlingAddress;
    maxSupply = _maxSupply;
  }

  // Mint a new egg NFT and decrease the remaining supply
  function mint(address _to) public {
    require(totalSupply() < maxSupply, "Max supply reached.");

    _mint(_to, _totalSupply() + 1);
  }

  // Hatching the egg destroys it and creates a new NFT of the specified type
  function hatch() public {
    require(!hatched, "Egg has already hatched.");
    require(hatchlingAddress != address(0), "Hatchling NFT address not specified.");

    // Create a new NFT of the specified type
    ERC721 hatchling = ERC721(hatchlingAddress);
    hatchling.mint(msg.sender);

    // Destroy the egg NFT
    _destroy(msg.sender, _tokenId());

    // Mark the egg as hatched
    hatched = true;
  }
}
