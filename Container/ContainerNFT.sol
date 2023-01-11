pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract ContainerNFT is ERC721 {
  // define data structure to store NFTs within the container NFT
  mapping (uint256 => address) public containedNFTs;
  
  // function to add NFTs to the container NFT
  function addNFT(address _contractAddress, uint256 _nftID) public {
    // retrieve NFT from provided contract address and ID
    ERC721 token = ERC721(_contractAddress);
    address nftOwner = token.ownerOf(_nftID);
    // ensure user is owner of NFT and has approval to transfer it
    require(msg.sender == nftOwner && token.isApprovedOrOwner(msg.sender, _nftID));
    // add NFT to container NFT's data structure
    containedNFTs[_nftID] = _contractAddress;
  }
  
  // function to view NFTs contained within the container NFT
  function viewContainedNFTs() public view returns (address[] memory) {
    // return array of contract addresses containing the NFTs
    return containedNFTs;
  }
  
  // function to remove NFTs from the container NFT
  function removeNFT(uint256 _nftID) public {
    // ensure user is owner of container NFT
    require(msg.sender == ownerOf(this));
    // delete NFT from container NFT's data structure
    delete containedNFTs[_nftID];
  }
}
