pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace {
  // define data structure to store NFTs available for sale
  struct NFT {
    address contractAddress;
    uint256 nftID;
    uint256 price;
  }
  mapping (address => NFT[]) public nfts;

  // function to add NFT to marketplace for sale
  function addNFT(address _contractAddress, uint256 _nftID, uint256 _price) public {
    // ensure user is owner of NFT
    ERC721 token = ERC721(_contractAddress);
    require(msg.sender == token.ownerOf(_nftID));
    // add NFT to marketplace
    nfts[msg.sender].push(NFT(_contractAddress, _nftID, _price));
  }

  // function to purchase NFT from marketplace
  function purchaseNFT(address _contractAddress, uint256 _nftID, uint256 _price) public payable {
    // retrieve NFT from marketplace
    NFT[] memory sellerNFTs = nfts[_contractAddress];
    NFT memory nft;
    for (uint256 i = 0; i < sellerNFTs.length; i++) {
      if (sellerNFTs[i].nftID == _nftID) {
        nft = sellerNFTs[i];
        break;
      }
    }
    // ensure NFT exists and price is correct
    require(nft.nftID == _nftID && nft.price == _price);
    // transfer NFT to buyer and transfer purchase price to seller
    ERC721 token = ERC721(_contractAddress);
    token.safeTransferFrom(msg.sender, address(this), _nftID);
    msg.sender.transfer(_price);
  }
}