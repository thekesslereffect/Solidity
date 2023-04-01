// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract gen3_Attributes{
    // recieves info from token id and converts to attribute string
    // future versions will include a level contract
    function getAttributes(uint _seed) public view returns(string memory){
        string memory _color = imageColors[_seed % imageColors.length];
        return string(
                abi.encodePacked(
                    '"attributes": [{"trait_type": "Elemental", "value": "',
                    getElemental(_seed),
                    '"},{"trait_type": "Chromosome", "value": "',
                    getChromosome(_seed),
                    // Add other attributes: Levels, etc.
                    '"}]'
                )
            );
    }
    

    function getChromosome(uint _seed) public pure returns(string memory){
        string memory chromosome;
        chromosome = (_seed % 2) == 1 ? "XX" : "XY";
    }

    string[3][] elementals = [["water", "normal", "grass", "rock", "ground"],["bug", "fire","poison", "fighting","flying"],["dragon", "ice", "psychic", "ghost", "electric"]];

    function getElemental(uint _seed) public pure returns(string memory){
        string memory elemental;
        string[5] memory common = elementals[0];
        string[5] memory rare = elementals[1];
        string[5] memory legendary = elementals[2];
        if ((_seed % 100) < 50) {
            elemental = common[_seed % common.length];
        } else if ((_seed % 100) < 75) {
            elemental = rare[_seed % rare.length];
        } else if ((_seed % 100) < 90) {
            elemental = legendary[_seed % legendary.length];
        } else {
            elemental = "unkown";
        } 
        return elemental;
    }

    function getColor(uint _seed, string memory _elemental) public returns(string[5] memory){
        // get the elemental and get colors based on it
        string[4][5] memory colors = elementalToColors(_seed);
        string[5] memory color;
        //num-colors = 5 num-shades = 4
        uint[5] memory indices = [_seed % 4, (_seed >> 32) % 4, (_seed >> 64) % 4, (_seed >> 96) % 4, (_seed >> 128) % 4];
        color[0] = colors[0][indices[0]];
        color[1] = colors[1][indices[1]];
        color[2] = colors[2][indices[2]];
        color[3] = colors[3][indices[3]];
        color[4] = colors[4][indices[4]];
        return color;
    }

    function elementalToColors(uint _seed) public returns(string[5] memory){
        string memory elemental = getElemental(_seed);
        if(keccak256(abi.encodePacked(elemental)) == keccak256(abi.encodePacked(elementals[0][0]))){
            // water
            return ['"#232428"','"#335056"','"#5a8a8f"','"#9dbe9f"','"#f7f0e9"'];
        }
    }

}

library Gen3_Color {
    function getColorsCommon() public pure returns(string[4][5] memory){
        string[4][5] memory colors = [
            ['"#232428"','"#302940"','"#422333"','"#76192d"'],
            ['"#335056"','"#404b67"','"#65474c"','"#ab2c2c"'],
            ['"#5a8a8f"','"#588195"','"#7b6561"','"#ed553b"'],
            ['"#9dbe9f"','"#9dbfbb"','"#bd9680"','"#f09a59"'],
            ['"#f7f0e9"','"#e5f5e7"','"#efead4"','"#f0ddb8"']
        ];
        return colors;
    }
    function getColorsRare() public pure returns(string[4][5] memory){
        string[4][5] memory colors = [
            ['"#101000"','"#102000"','"#103000"','"#104000"'],
            ['"#111000"','"#112000"','"#113000"','"#114000"'],
            ['"#121000"','"#122000"','"#123000"','"#124000"'],
            ['"#131000"','"#132000"','"#133000"','"#134000"'],
            ['"#141000"','"#142000"','"#143000"','"#144000"']
        ];
        return colors;

    }
    function getColorsLegendary() public pure returns(string[4][5] memory){
        string[4][5] memory colors = [
            ['"#201000"','"#202000"','"#203000"','"#204000"'],
            ['"#211000"','"#212000"','"#213000"','"#214000"'],
            ['"#221000"','"#222000"','"#223000"','"#224000"'],
            ['"#231000"','"#232000"','"#233000"','"#234000"'],
            ['"#241000"','"#242000"','"#243000"','"#244000"']
        ];
        return colors;
    }
}