// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';
import '@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';

contract TPCXStore is ERC1155Holder, Ownable, Pausable {
    using SafeERC20 for IERC20;
    IERC20 public IERC20Address;
    address public ERC20ReceiverAddress;

    // Time And Counter
    mapping(address => uint256) public nextPurchaseDate;
    mapping(address => uint256) public availablePurchases;
    mapping(address => bool) public exclusiveHolder;
    mapping(address => uint256) public counter;
    uint256 waitTime;
    uint256 purchasesAvailableDefault;
    uint256 purchasesAvailableExclusive;

    // exclusive perks for holders of these ids
    address[] exclusiveTokenContracts = [
        0x2953399124F0cBB46d2CbACD8A89cF0599974963
        ];

    uint256[] exclusiveTokenIds = [
        2028626844729816297473413048497949099433804772995310846604280455040849674265
        ];

    // tokens in store
    address[] tokenContracts = [
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963,
        0x2953399124F0cBB46d2CbACD8A89cF0599974963
        ];

    uint256[] tokenIds = [
        2028626844729816297473413048497949099433804772995310846604280457239873029792,
        2028626844729816297473413048497949099433804772995310846604280453941338050908,
        2028626844729816297473413048497949099433804772995310846604280456140361306460
        ];

    uint256[] tokenIdsCost = [
        50000,
        50000,
        50000
    ];
    
    constructor(IERC20 _ERC20Address, address _ERC20ReceiverAddress) {
        IERC20Address = _ERC20Address;
        ERC20ReceiverAddress = _ERC20ReceiverAddress;
        purchasesAvailableDefault = 1;
        purchasesAvailableExclusive = 2;
        waitTime = 1440;
    }
    
    function buyItems(uint256 _itemId, uint256 _amount) external whenNotPaused{
        require(IERC1155(tokenContracts[_itemId]).balanceOf(address(this), tokenIds[_itemId]) >= _amount);
        require(IERC20Address.balanceOf(msg.sender)>=(tokenIdsCost[_itemId]*10**18)*_amount);
        // TIMER AND COUNTER FUNCTION
        require(block.timestamp >=  nextPurchaseDate[msg.sender], "You can't do that right now. Come back later." );
        if(counter[msg.sender] == 0 ){
            checkIfExclusiveHolder();
            resetAvailablePurchases();
            counter[msg.sender] = 1;
        }
        if(availablePurchases[msg.sender] > 1){
            checkIfExclusiveHolder();
            availablePurchases[msg.sender] --;
        }else{
            checkIfExclusiveHolder();
            setNextPurchaseDate();
            resetAvailablePurchases();
        }
        // BUY!!!
        IERC20Address.transferFrom(msg.sender,ERC20ReceiverAddress,(tokenIdsCost[_itemId]*10**18)*_amount);
        IERC1155(tokenContracts[_itemId]).safeTransferFrom(address(this), msg.sender, tokenIds[_itemId], _amount, "");
        emit ERC20Sent(msg.sender, tokenIdsCost[_itemId]*_amount);
        emit NFTBought(msg.sender, tokenIds[_itemId], _amount);
    }

    // TIMER AND COUNTER FUNCTIONS /////////////////////////////////////////////////////////
    
    function setWaitTime(uint256 _waitTime) external onlyOwner {
        waitTime = _waitTime;
    }

    function setPurchaseLimits(uint256 _default, uint256 _exclusive) external onlyOwner {
        purchasesAvailableDefault = _default;
        purchasesAvailableExclusive = _exclusive;
    }

    function viewUserCanPurchase(address _address) public view returns(bool){
        return block.timestamp >=  nextPurchaseDate[_address];
    }

    function viewUserOwnsExclusive(address _address) public view returns(bool){
        uint256 _holdings;
        uint256 _len = exclusiveTokenIds.length;
        for(uint i=0; i < _len; i++){
            _holdings += IERC1155(exclusiveTokenContracts[i]).balanceOf(_address,exclusiveTokenIds[i]);
        }
        return _holdings > 0;
    }

    function checkIfExclusiveHolder() private{
        uint256 _holdings;
        uint256 _len = exclusiveTokenIds.length;
        for(uint i=0; i < _len; i++){
            _holdings += IERC1155(exclusiveTokenContracts[i]).balanceOf(msg.sender,exclusiveTokenIds[i]);
        }
        exclusiveHolder[msg.sender] = _holdings > 0;
    }

    function setNextPurchaseDate() private {
        nextPurchaseDate[msg.sender] = block.timestamp + (waitTime * 1 minutes);
    }

    function resetAvailablePurchases() private {
        if(exclusiveHolder[msg.sender]){
            availablePurchases[msg.sender] = purchasesAvailableExclusive;
        }else{
            availablePurchases[msg.sender] = purchasesAvailableDefault;
        }
    }

    function removeExclusiveToken(uint _index) external onlyOwner{
        require(_index < exclusiveTokenIds.length, "index out of bound");
        uint256 _len = exclusiveTokenIds.length;
        for (uint i = _index; i < _len - 1; i++) {
            exclusiveTokenContracts[i] = exclusiveTokenContracts[i + 1];
            exclusiveTokenIds[i] = exclusiveTokenIds[i + 1];
           
        }
        exclusiveTokenContracts.pop();
        exclusiveTokenIds.pop();
    }

    function addExclusiveToken(address _exclusiveTokenContract, uint256 _exclusiveTokenId) external onlyOwner{
        exclusiveTokenContracts.push(_exclusiveTokenContract);
        exclusiveTokenIds.push(_exclusiveTokenId);
    }

    function viewExclusiveTokenContracts() public view returns(address[] memory){
        return exclusiveTokenContracts;
    }

    function viewExclusiveTokenIds() public view returns(uint256[] memory){
        return exclusiveTokenIds;
    }

    // VIEW FUNCTIONS /////////////////////////////////////////////////////////
    function _viewTokenContracts() public view returns (address[] memory) {
        return tokenContracts;
    }

    function _viewTokenIds() public view returns (uint256[] memory) {
        return tokenIds;
    }

    function _viewTokenIdsCost() public view returns (uint256[] memory) {
        return tokenIdsCost;
    }

    function _viewTokenBalances() public view returns (uint256[] memory) {
        uint256 _len = tokenIds.length;
        uint256[] memory _tokenBalances = new uint256[](_len);
        for (uint i = 0; i < _len; i++) {
            uint256 _bal = (IERC1155(tokenContracts[i]).balanceOf(address(this), tokenIds[i]));
            if(_bal > 0){
                _tokenBalances[i] = _bal;
            } else {
                _tokenBalances[i] = 0;
            }
                
        }

        return _tokenBalances;
    }

    // MUTATIVE FUNCTIONS /////////////////////////////////////////////////////////

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
    
    function removeTokenFromStore(uint _index) external onlyOwner{
        require(_index < tokenIds.length, "index out of bound");
        uint256 _len = tokenIds.length;
        for (uint i = _index; i < _len - 1; i++) {
            tokenContracts[i] = tokenContracts[i + 1];
            tokenIds[i] = tokenIds[i + 1];
            tokenIdsCost[i] = tokenIdsCost[i + 1];
        }
        tokenContracts.pop();
        tokenIds.pop();
        tokenIdsCost.pop();
    }

    function addTokenToStore(address _tokenContract, uint256 _tokenId, uint256 _tokenIdCost) external onlyOwner{
        tokenContracts.push(_tokenContract);
        tokenIds.push(_tokenId);
        tokenIdsCost.push(_tokenIdCost);
    }

    function changeERC20Receiver(address _ERC20ReceiverAddress) external onlyOwner{
        ERC20ReceiverAddress = _ERC20ReceiverAddress;
    }

    function changeERC20Address(IERC20 _ERC20Address) external onlyOwner{
        IERC20Address = _ERC20Address;
    }

    function withdrawERC20() external onlyOwner{
        IERC20Address.transfer(msg.sender,IERC20Address.balanceOf(address(this)));
    }

    function withdrawERC1155(uint256 _itemId, uint256 _amount) external onlyOwner{
         IERC1155(tokenContracts[_itemId]).safeTransferFrom(address(this), msg.sender, tokenIds[_itemId], _amount,"");
    }

    // EVENTS /////////////////////////////////////////////////////////

    event ERC20Sent(address _owner, uint256 _value);
    event NFTBought(address _owner, uint256 _tokenId, uint256 _value);

}