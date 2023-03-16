pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TrashMarketMaker {
    IERC20 public trash;
    IERC20 public matic;
    uint256 public trashBalance;
    uint256 public maticBalance;
    uint256 private constant PRECISION = 10 ** 18;
    uint256 private constant FEE = 0.01 * PRECISION; // 1% fee

    event Buy(address indexed buyer, uint256 amount);
    event Sell(address indexed seller, uint256 amount);
    event AddLiquidity(address indexed provider, uint256 amountMatic, uint256 amountTrash);
    event RemoveLiquidity(address indexed provider, uint256 amountMatic, uint256 amountTrash);

    constructor(IERC20 _trash, IERC20 _matic) {
        trash = _trash;
        matic = _matic;
    }

    function buy() public payable {
        uint256 maticAmount = msg.value;
        uint256 trashAmount = getBuyAmount(maticAmount);

        require(trashAmount > 0, "Insufficient liquidity");
        require(trash.transfer(msg.sender, trashAmount), "Transfer failed");

        uint256 fee = (trashAmount * FEE) / PRECISION;
        uint256 actualTrashAmount = trashAmount - fee;

        trashBalance += actualTrashAmount;
        maticBalance += maticAmount;
        emit Buy(msg.sender, actualTrashAmount);
    }

    function sell(uint256 trashAmount) public {
        require(trashAmount > 0, "Invalid amount");

        uint256 maticAmount = getSellAmount(trashAmount);

        require(maticAmount > 0 && matic.balanceOf(address(this)) >= maticAmount, "Insufficient liquidity");
        require(trash.transferFrom(msg.sender, address(this), trashAmount), "Transfer failed");
        require(matic.transfer(msg.sender, maticAmount), "Transfer failed");

        uint256 fee = (maticAmount * FEE) / PRECISION;
        uint256 actualMaticAmount = maticAmount - fee;

        trashBalance += trashAmount;
        maticBalance += actualMaticAmount;
        emit Sell(msg.sender, trashAmount);
    }

    function addLiquidity(uint256 amountMatic, uint256 amountTrash) public {
        require(amountMatic > 0 && amountTrash > 0, "Invalid amount");

        uint256 maticReserve = matic.balanceOf(address(this));
        uint256 trashReserve = trash.balanceOf(address(this));

        uint256 liquidity;
        if (maticReserve == 0 || trashReserve == 0) {
            liquidity = amountMatic * amountTrash;
        } else {
            uint256 amount = (amountMatic * trashReserve) / maticReserve;
            require(amount <= amountTrash, "Invalid amount");
            liquidity = (amountMatic * trashBalance) / maticBalance;
        }

        require(matic.transferFrom(msg.sender, address(this), amountMatic), "Transfer failed");
        require(trash.transferFrom(msg.sender, address(this), amountTrash), "Transfer failed");

        maticBalance += amountMatic;
        trashBalance += amountTrash;

        emit AddLiquidity(msg.sender, amountMatic, amountTrash);
    }

    function removeLiquidity(uint256 amount) public {
        require(amount > 0, "Invalid amount");

        uint256 maticAmount = (amount * maticBalance) / trashBalance;
        uint256 trashAmount = (amount * trashBalance) / maticBalance;

        require(maticAmount > 0 && trashAmount > 0, "Insufficient liquidity");
        require(matic.transfer(msg.sender, maticAmount), "Transfer failed");
        require(trash.transfer(msg.sender, trashAmount), "Transfer failed");

        maticBalance -= maticAmount;
        trashBalance -= trashAmount;

        emit RemoveLiquidity(msg.sender, maticAmount, trashAmount);
    }

    function getBuyAmount(uint256 maticAmount) public view returns (uint256) {
        return (sqrt(maticBalance * trashBalance * (maticAmount * PRECISION + maticBalance * PRECISION)) - maticBalance * PRECISION) / PRECISION;
    }

    function getSellAmount(uint256 trashAmount) public view returns (uint256) {
        return (maticBalance * PRECISION - sqrt(maticBalance * trashBalance * (maticBalance * PRECISION - trashAmount * PRECISION))) / PRECISION;
    }

    function sqrt(uint256 x) private pure returns (uint256) {
        uint256 y = x;
        while (true) {
            uint256 z = (y + (x / y)) / 2;
            if (z >= y) {
                return y;
            }
            y = z;
        }
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner(), "Unauthorized");
        require(amount <= address(this).balance, "Insufficient balance");
        payable(msg.sender).transfer(amount);
    }

    function withdrawERC20(IERC20 token, uint256 amount) public {
        require(msg.sender == owner(), "Unauthorized");
        require(amount <= token.balanceOf(address(this)), "Insufficient balance");
        require(token.transfer(msg.sender, amount), "Transfer failed");
    }
}

