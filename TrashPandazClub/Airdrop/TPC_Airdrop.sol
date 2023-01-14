mapping (uint256 => address) public tokenHolders;

function getHolders() public view returns (address[] memory) {
    address[] memory holders = new address[](tokenHolders.length);
    uint256 i = 0;
    for (uint256 tokenId = 1; tokenId <= tokenHolders.length; tokenId++) {
        if (tokenHolders[tokenId] != address(0)) {
            holders[i] = tokenHolders[tokenId];
            i++;
        }
    }
    return holders;
}