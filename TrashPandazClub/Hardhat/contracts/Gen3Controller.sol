// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IGen3Token{
    function mint(address _address) external;
    function hatch(address _address, uint _tokenId) external;
    function mutate(address _address, uint _tokenId) external;
    function mintCollab(address _address, string memory _projectName, string[4] memory _colors) external;
    function customColorForUnknown(address _address, uint _tokenId, string[4] memory _colors) external;
}

contract Gen3Controller is AccessControl{
    using SafeERC20 for ERC20;

    address public erc20Token;
    address public gen3_tokenContract;

    uint public trashPrice;
    uint public maticPrice;

    // Restrictions
    mapping(address => uint) public recentMint;
    uint public mintCooldown;
    bool enableMutation;
    bool enableHatching;
    bool enableMintWithTrash;
    bool enableMintWithMatic;

    constructor(address _gen3_tokenContract, address _erc20Token){
        gen3_tokenContract = _gen3_tokenContract;
        erc20Token = _erc20Token;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        mintCooldown = 1 days;
        trashPrice = 10000;
        maticPrice = 10;
        enableMutation = false;
        enableHatching = true;
        enableMintWithTrash = true;
        enableMintWithMatic = false;
    }

    // MINT

    function mintWithTrash() public returns(bool){
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) == false){
            require(enableMintWithTrash == true,"Minting with Trash is paused at the moment. Check back later.");
            require(block.timestamp - recentMint[msg.sender] >= mintCooldown, "Slow down there bub! Come back later." );
            require(ERC20(erc20Token).allowance(msg.sender, address(this)) >= (trashPrice*10**18), "Insufficient allowance");
            ERC20(erc20Token).safeTransferFrom(msg.sender, address(this), (trashPrice*10**18));  
        }
        mint(msg.sender);
        return true;
    }

    function mintWithMatic() public payable returns(bool){
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) == false){
            require(enableMintWithMatic == true,"Minting with Matic is paused at the moment. Check back later.");
            require(block.timestamp - recentMint[msg.sender] >= mintCooldown, "Slow down there bub! Come back later." );
            require(msg.value == (maticPrice * 1 ether), "Please send the correct Matic");
        }
        mint(msg.sender);
        return true;
    }

    // ADMIN MINT FUNCTIONS

    function admin_Mint(address _address) public onlyRole(DEFAULT_ADMIN_ROLE) returns(bool){
        mint(_address);
        return true;
    }

    function admin_MintCollab(address _address, string memory _projectName, string[4] memory _colors) public onlyRole(DEFAULT_ADMIN_ROLE) returns(bool){
        IGen3Token(gen3_tokenContract).mintCollab(_address, _projectName, _colors);
        return true;
    }

    function mint(address _address) private{
        IGen3Token(gen3_tokenContract).mint(_address);
    }

    // HATCH

    function hatch(uint _tokenId) public returns(bool){
        require(enableHatching == true,"Hatching is paused at the moment. Check back later.");
        IGen3Token(gen3_tokenContract).hatch(msg.sender, _tokenId);
        return true;
    }
    
    // MUTATE
    function mutate(uint _tokenId) public returns(bool){
        if(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) == false){
            require(enableMutation == true,"Mutations are disabled.");
        }
        IGen3Token(gen3_tokenContract).mutate(msg.sender, _tokenId);
        return true;
    }

    // Custom Unknown Color
    function customColorForUnknown(uint _tokenId, string[4] memory _colors) public returns(bool){
        IGen3Token(gen3_tokenContract).customColorForUnknown(msg.sender, _tokenId, _colors);
        return true;
    }

    // ADMIN FUNCTIONS
    
    // Set gen3 contract
    function setIGen3TokenContract(address _gen3_tokenContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3_tokenContract = _gen3_tokenContract;
    }
    // Set + Remove token
    function setERC20Token(address _erc20Token) public onlyRole(DEFAULT_ADMIN_ROLE){
        erc20Token = _erc20Token;
    }
    function removeTokens(address recipient, uint256 _tokenAmount) external onlyRole(DEFAULT_ADMIN_ROLE){
        ERC20(erc20Token).safeTransfer(recipient, _tokenAmount);
    }
    function removeMatic(address payable recipient) external onlyRole(DEFAULT_ADMIN_ROLE){
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
    // enable mutations
    function setMutation(bool _enableMutation) public onlyRole(DEFAULT_ADMIN_ROLE){
        enableMutation = _enableMutation;
    }
    // enable hatching
    function setHatching(bool _enableHatching) public onlyRole(DEFAULT_ADMIN_ROLE){
        enableHatching = _enableHatching;
    }
    // enable minting
    function setMintWithMatic(bool _enableMintWithMatic) public onlyRole(DEFAULT_ADMIN_ROLE){
        enableMintWithMatic = _enableMintWithMatic;
    }
    function setMintWithTrash(bool _enableMintWithTrash) public onlyRole(DEFAULT_ADMIN_ROLE){
        enableMintWithTrash = _enableMintWithTrash;
    }

}
