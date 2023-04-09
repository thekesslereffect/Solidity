// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.3/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TPCEcoWallet is ReentrancyGuard, AccessControl{
    using SafeMath for *;
    using SafeERC20 for IERC20;
    IERC20 public erc20Token;
    mapping(address=>uint) ERC20BALANCE;
    mapping(address=>uint) MATICBALANCE;
    uint virtualContractERC20Balance;
    uint virtualContractMATICBalance;

    bytes32 public constant CONTROLLER_ROLE = keccak256("CONTROLLER_ROLE"); 

    constructor(IERC20 _erc20Token){
        erc20Token = _erc20Token;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(CONTROLLER_ROLE, msg.sender);
    }
    
    // Events ...........................................
    
    event ERC20BalanceWithdrawn(address indexed user,uint256 amount);
    event ERC20BalanceDeposited(address indexed user,uint256 amount);
    event ERC20BalanceAdded(address indexed user,uint256 _amount);
    event ERC20BalanceRemoved(address indexed user,uint256 _amount);
    event MATICBalanceWithdrawn(address indexed user,uint256 amount);
    event MATICBalanceDeposited(address indexed user,uint256 amount);

    // User Functions ........................................

    function depositERC20BALANCE(uint _amount) public {
        require(
            erc20Token.allowance(msg.sender, address(this)) >= _amount &&
            erc20Token.balanceOf(msg.sender) >= _amount,
            "Insufficient balance or allowance."
        );
        erc20Token.safeTransferFrom(msg.sender, address(this), _amount);
        ERC20BALANCE[msg.sender] += _amount;
        emit ERC20BalanceDeposited(msg.sender,_amount);
        virtualContractERC20Balance += _amount;
    }

    function withdrawERC20BALANCE(uint _amount) public nonReentrant{
        uint _bal = ERC20BALANCE[msg.sender];
        require(_bal >= _amount, "Insufficient balance for that amount.");
        erc20Token.safeTransfer(msg.sender, _amount);
        ERC20BALANCE[msg.sender] = _bal - _amount;
        emit ERC20BalanceWithdrawn(msg.sender,_amount);
        virtualContractERC20Balance -= _amount;
    }

    function depositMATICBALANCE() public payable {
        uint _amount = msg.value;
        MATICBALANCE[msg.sender] += _amount;
        emit MATICBalanceDeposited(msg.sender,_amount);
        virtualContractMATICBalance += _amount;
    }

    function withdrawMATICBALANCE(uint _amount) public nonReentrant{
        uint _bal = MATICBALANCE[msg.sender];
        require(_bal >= _amount, "Insufficient balance for that amount.");
        payable(msg.sender).transfer(_amount);
        MATICBALANCE[msg.sender] = _bal - _amount;
        emit MATICBalanceWithdrawn(msg.sender,_amount);
        virtualContractMATICBalance -= _amount;
    }

    // Controller Functions ..............................

    function addERC20Balance(address _account, uint _amount) external onlyRole(CONTROLLER_ROLE){
        ERC20BALANCE[_account] += _amount;
        virtualContractERC20Balance -= _amount;
        emit ERC20BalanceAdded(_account, _amount);
    }

    function removeERC20Balance(address _account, uint _amount) external onlyRole(CONTROLLER_ROLE){
        require(ERC20BALANCE[_account]>=_amount, "This user doesnt have enough to remove from. Revert");
        ERC20BALANCE[_account] -= _amount;
        virtualContractERC20Balance += _amount;
        emit ERC20BalanceRemoved(_account, _amount);
    }

    // View ..............................................

    function viewERC20BALANCE(address _account) external view returns(uint){
        return ERC20BALANCE[_account];
    }

    function viewMATICBALANCE(address _account) external view returns(uint){
        return MATICBALANCE[_account];
    }

    function viewContractERC20Funds() public view returns(uint){
        return erc20Token.balanceOf(address(this));
    }

    function viewContractMATICFunds() public view returns(uint){
        return address(this).balance;
    }

    function viewDeveloperERC20Funds() public view returns(uint){
        uint _funds = virtualContractERC20Balance - erc20Token.balanceOf(address(this));
        return _funds;
    }

    function viewDeveloperMATICFunds() public view returns(uint){
        uint _funds = virtualContractMATICBalance - address(this).balance;
        return _funds;
    }

    // Allows an admin to set a new ERC20 token as the currency for giveaways
    function setERC20Token(IERC20 _erc20Token) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(address(_erc20Token) != address(0), "Invalid ERC20 token");
        erc20Token = _erc20Token;
    }

    // Allows an admin to remove developer funds from the contract
    function removeDeveloperERC20Funds(uint _amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        uint _funds = virtualContractERC20Balance - erc20Token.balanceOf(address(this));
        require(_amount <= _funds, "You cant withdraw more than the dev funds.");
        erc20Token.safeTransferFrom(address(this), msg.sender, _amount);
    }

    // Allows an admin to remove developer funds from the contract
    function removeDeveloperMATICFunds(uint _amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        uint _funds = virtualContractMATICBalance - address(this).balance;
        require(_amount <= _funds, "You cant withdraw more than the dev funds.");
        payable(msg.sender).transfer(_amount);
    }

}
