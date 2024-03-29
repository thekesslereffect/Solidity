// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IGen3Image{
    function getColor(string memory _elemental) external view returns(string[4][4] memory);
    function getMutationColor() external view returns(string[4][4][15] memory);
}

contract Gen3Attributes is AccessControl{
    address public gen3_ImageContract;
    string[][] elementals;

    constructor(address _gen3_ImageContract){
        gen3_ImageContract = _gen3_ImageContract;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        elementals = [["water","normal","grass","rock","ground"],["bug","fire","poison","fighting","flying"],["dragon","ice","psychic","ghost","electric"],["unknown","unknown","unknown","unknown","unknown"]];
    }

    function getExtraAttributes(uint _seed) external view returns(string memory){
        return string(
                abi.encodePacked(
                    "" // remove this and add extra attributes like Levels etc.
                    // Example
                    // ',{"trait_type": "Level", "value": "',
                    // "1",
                    // '"}'
                    
                )
            );
    }

    // CHROMOSOMES

    function getChromosome(uint _seed) external view returns(string memory chromosome){
        chromosome = (uint256(keccak256(abi.encode(_seed))) % 2) == 1 ? "XX" : "XY";
    }

    // ELEMENTALS

    function getElemental(uint _seed) external view returns(string memory){
        string memory elemental;
        string[] memory common = elementals[0];
        string[] memory rare = elementals[1];
        string[] memory legendary = elementals[2];
        if ((uint256(keccak256(abi.encode(_seed))) % 100) < 50) {
            elemental = common[uint256(keccak256(abi.encode(_seed))) % common.length];
        } else if ((uint256(keccak256(abi.encode(_seed))) % 100) < 80) {
            elemental = rare[uint256(keccak256(abi.encode(_seed))) % rare.length];
        } else if ((uint256(keccak256(abi.encode(_seed))) % 100) < 95) {
            elemental = legendary[uint256(keccak256(abi.encode(_seed))) % legendary.length];
        } else {
            elemental = "unknown";
        } 
        return elemental;
    }

    // COLORS

    function getColor(uint _seed) external view returns(string[4] memory){
        string memory elemental = this.getElemental(_seed);
        string[4][4] memory color = IGen3Image(gen3_ImageContract).getColor(elemental);
        string[4] memory result;

        for (uint256 i = 0; i < 4; i++) {
            uint256 randomIndex = uint256(keccak256(abi.encode(_seed, i))) % color[i].length;
            result[i] = color[i][randomIndex];
        }

        return result;
    }
    
    function getMutationColor(uint _seed) external view returns(string[4] memory){
        string memory elemental = this.getElemental(_seed);
        string[4][4][15] memory color = IGen3Image(gen3_ImageContract).getMutationColor();
        string[4] memory result;

        for (uint256 i = 0; i < 4; i++) {
            uint256 randomElementalIndex = uint256(keccak256(abi.encode(_seed, i))) % color[i].length;
            uint256 randomIndex = uint256(keccak256(abi.encode(_seed, i))) % color[i][i].length;
            result[i] = color[randomElementalIndex][i][randomIndex];
        }

        return result;
    }

    function setGen3_ImageContract(address _gen3_ImageContract) public onlyRole(DEFAULT_ADMIN_ROLE){
        gen3_ImageContract = _gen3_ImageContract;
    }

    function setElementals(string[][] memory _elementals) public onlyRole(DEFAULT_ADMIN_ROLE){
        elementals = _elementals;
    }
}