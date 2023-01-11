pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract LevelUpNFT is ERC721 {
  // define data structure to store NFT levels and corresponding image URLs
  mapping (uint256 => string) public levels;

  // function to level up the NFT
  function levelUp() public {
    // ensure user is owner of NFT
    require(msg.sender == ownerOf(this));
    // increase NFT level and update image using corresponding image URL
    uint256 currentLevel = levels[this];
    levels[this] = currentLevel + 1;
    setTokenURI(this, levels[this]);
  }
}