// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20_Base is ERC20, ERC20Burnable, ERC20Permit, Ownable {
    constructor() ERC20("TRASH2.0", "TRASH2.0") ERC20Permit("TRASH2.0") {
        _mint(msg.sender, 4444000000 * 10 ** decimals());
    }
}