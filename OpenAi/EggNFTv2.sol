pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC1155.sol";

// Set the max number of eggs that can be minted
uint256 private constant MAX_EGG_SUPPLY = 10000;

// Define the different rarity levels and the percentage chance of each rarity being picked
enum Rarity {
  Common,
  Rare,
  Epic,
  Legendary
}

uint8 private constant RARITY_CHANCES = [20, 10, 5, 1];

// Map the rarity level to the corresponding image URI
string private constant IMAGE_URIS = [
  "https://example.com/common.png",
  "https://example.com/rare.png",
  "https://example.com/epic.png",
  "https://example.com/legendary.png"
];

// The ERC1155 contract that represents the eggs
contract EggToken is ERC1155 {
  // The number of eggs that have been minted so far
  uint256 private eggCount;

  // The mapping of egg IDs to their rarity level and image URI
  mapping(uint256 => Rarity) public eggRarities;
  mapping(uint256 => string) public eggImageUris;

  // The constructor function that initializes the contract
  constructor() public {
    eggCount = 0;
  }

  // The function to mint a new egg
  function mintEgg() public {
    require(eggCount < MAX_EGG_SUPPLY, "Max egg supply reached");

    // Pick a rarity level for the egg using the defined rarity chances
    Rarity rarity = pickRarity();

    // Increment the egg count and set the rarity and image URI for the new egg
    eggCount++;
    eggRarities[eggCount] = rarity;
    eggImageUris[eggCount] = IMAGE_URIS[uint8(rarity)];

    // Set the rarity and image URI as metadata for the new egg
    _setTokenMetadata(eggCount, stringToBytes(IMAGE_URIS[uint8(rarity)]), stringToBytes(bytes(rarity)));

    // Mint the new egg
    _mint(msg.sender, eggCount, 1);
  }

  // The function to pick a rarity level based on the defined rarity chances
  function pickRarity() private view returns (Rarity) {
    uint8 roll = random();
    uint8 totalChance = 0;
    for (uint8 i = 0; i < 4; i++) {
      totalChance += RARITY_CHANCES[i];
      if (roll < totalChance) {
        return Rarity(i);
      }
    }
  }

  // The function to update the metadata for an egg
  function updateEggMetadata(uint256 eggId, string imageUri, Rarity rarity) public {
    // Only the contract owner can update the metadata
    require(msg.sender == owner(), "Only the contract owner can update the metadata");

// Update the rarity and image URI for the egg
eggRarities[eggId] = rarity;
eggImageUris[eggId] = imageUri;

// Set the updated rarity and image URI as metadata for the egg
_setTokenMetadata(eggId, stringToBytes(imageUri), stringToBytes(bytes(rarity)));
  }
  }
  
