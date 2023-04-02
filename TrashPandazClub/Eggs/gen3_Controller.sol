// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IGen3_Token{
    function mint(address _sender) external;
}

contract Gen3_Controller is AccessControl{
    using SafeERC20 for ERC20;

    address public erc20Token;
    address public gen3_tokenContract;

    uint public trashPrice  = 10000;
    uint public maticPrice = 10;

    // Restrictions
    mapping(address => uint) public recentMint;
    uint public mintCooldown;

    bytes32 public constant BANKER_ROLE = keccak256("BANKER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address _gen3_tokenContract, address _erc20Token){
        gen3_tokenContract = _gen3_tokenContract;
        erc20Token = _erc20Token;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BANKER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        mintCooldown = 1 days;
    }

    function mintWithTrash(address _minter) public returns(bool){
        if(hasRole(DEFAULT_ADMIN_ROLE, _minter) == false){
            require(block.timestamp - recentMint[_minter] >= mintCooldown, "Slow down there bub! Come back later." );
            require(ERC20(erc20Token).allowance(_minter, address(this)) >= (trashPrice*10**18), "Insufficient allowance");
            ERC20(erc20Token).safeTransferFrom(_minter, address(this), (trashPrice*10**18));  
        }
        
        mint(_minter);
        //handle transaction
        return true;
    }

    function mintWithMatic(address _minter) public payable returns(bool){
        if(hasRole(DEFAULT_ADMIN_ROLE, _minter) == false){
            require(block.timestamp - recentMint[_minter] >= mintCooldown, "Slow down there bub! Come back later." );
            require(msg.value == (maticPrice * 1 ether), "Please send the correct Matic");
        }
        mint(_minter);
        //handle transaction
        return true;
    }

    function mint(address _minter) private returns(bool){
        IGen3_Token(gen3_tokenContract).mint(_minter);
        return true;
    }


    // Setter functions
    // Set gen3 contract
    function setIGen3_TokenContract(address _gen3_tokenContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3_tokenContract = _gen3_tokenContract;
    }
    // Set + Remove token
    function setERC20Token(address _erc20Token) public onlyRole(DEFAULT_ADMIN_ROLE){
        erc20Token = _erc20Token;
    }
    function removeTokens(address recipient, uint256 _tokenAmount) external onlyRole(BANKER_ROLE){
        ERC20(erc20Token).safeTransfer(recipient, _tokenAmount);
    }
    function removeMatic(address payable recipient) external onlyRole(BANKER_ROLE){
        recipient.transfer(address(this).balance);
    }
    // Set Mint Price
    function setTrashPrice(uint _trashPrice) public onlyRole(DEFAULT_ADMIN_ROLE){
        trashPrice = _trashPrice;
    }
    function setMaticPrice(uint _maticPrice) public onlyRole(DEFAULT_ADMIN_ROLE){
        maticPrice = _maticPrice;
    }
    // Set Mint cooldown
    function setMintCooldown(uint _mintCooldown) public onlyRole(DEFAULT_ADMIN_ROLE){
        mintCooldown = _mintCooldown;
    }

    


}
