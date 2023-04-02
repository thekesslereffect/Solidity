// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract gen3_Attributes{

    function getAttributes(uint _seed, string[] memory _color) public view returns(string memory){
        return string(
                abi.encodePacked(
                    '{"trait_type": "Elemental", "value": "',
                    getElemental(_seed),
                    '"},{"trait_type": "Chromosome", "value": "',
                    getChromosome(_seed),
                    '"},{"trait_type": "Color 1", "value": "',
                    _color[0],
                    '"},{"trait_type": "Color 2", "value": "',
                    _color[1],
                    '"},{"trait_type": "Color 3", "value": "',
                    _color[2],
                    '"},{"trait_type": "Color 4", "value": "',
                    _color[3],
                    '"},{"trait_type": "Color 5", "value": "',
                    _color[4],
                    // Add other attributes: Levels, Colors, etc.
                    '"}'
                )
            );
    }

    // CHROMOSOMES

    function getChromosome(uint _seed) public pure returns(string memory chromosome){
        chromosome = (_seed % 2) == 1 ? "XX" : "XY";
    }

    // ELEMENTALS

    string[][] elementals = [["water", "normal", "grass", "rock", "ground"],["bug", "fire","poison", "fighting","flying"],["dragon", "ice", "psychic", "ghost", "electric"],["unknown","unknown","unknown","unknown","unknown"]];

    function getElemental(uint _seed) public view returns(string memory){
        string memory elemental;
        string[] memory common = elementals[0];
        string[] memory rare = elementals[1];
        string[] memory legendary = elementals[2];
        if ((_seed % 100) < 50) {
            elemental = common[_seed % common.length];
        } else if ((_seed % 100) < 75) {
            elemental = rare[_seed % rare.length];
        } else if ((_seed % 100) < 90) {
            elemental = legendary[_seed % legendary.length];
        } else {
            elemental = "unknown";
        } 
        return elemental;
    }

    // COLORS

    string[][][] elementalsColors = [[
        // Common
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"']
        ],[
        // rare
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"']
        ],[
        // legendary
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'],
        ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"']
        ],[
        // unknown
        ['"#222222"','"#444444"','"#888888"','"#aaaaaa"','"#f7f0e9"'],
        ['"#222222"','"#444444"','"#888888"','"#aaaaaa"','"#f7f0e9"'],
        ['"#222222"','"#444444"','"#888888"','"#aaaaaa"','"#f7f0e9"'],
        ['"#222222"','"#444444"','"#888888"','"#aaaaaa"','"#f7f0e9"'],
        ['"#222222"','"#444444"','"#888888"','"#aaaaaa"','"#f7f0e9"']
        ]];

    function getColor(uint _seed) public view returns(string[] memory color){
        string memory elemental = getElemental(_seed);
        for(uint i=0; i<elementals.length;i++){
            for(uint j=0; j<elementals[i].length; j++){
                if(keccak256(abi.encodePacked(elemental)) == keccak256(abi.encodePacked(elementals[i][j]))){
                    color = elementalsColors[i][j];
                }
            }
        }
    }

}