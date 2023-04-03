// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Gen3_Colors{
    // Common water,normal,grass,rock,ground
    string[4][5] cWater = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cNormal = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cGrass = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cRock = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cGround = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    // Rare bug,fire,poison,fighting,flying
    string[4][5] cBug = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cFire = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cPoison = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cFighting = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cFlying = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    // Legendary dragon,ice,psychic,ghost,electric
    string[4][5] cDragon = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cIce = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cPsychic = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cGhost = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cElectric = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];
    string[4][5] cUnknown = [
        ["#232428","#232428","#232428","#232428"],
        ["#335056","#335056","#335056","#335056"],
        ["#5a8a8f","#5a8a8f","#5a8a8f","#5a8a8f"],
        ["#9dbe9f","#9dbe9f","#9dbe9f","#9dbe9f"],
        ["#f7f0e9","#f7f0e9","#f7f0e9","#f7f0e9"]
    ];


    // Common water,normal,grass,rock,ground
    // Rare bug,fire,poison,fighting,flying
    // Legendary dragon,ice,psychic,ghost,electric
    function getColor(string memory _elemental) external view returns(string[4][5] memory color){
        if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("water"))){
            return water();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("normal"))){
            return normal();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("grass"))){
            return grass();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("rock"))){
            return rock();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("ground"))){
            return ground();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("bug"))){
            return bug();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("fire"))){
            return fire();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("poison"))){
            return poison();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("fighting"))){
            return fighting();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("flying"))){
            return flying();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("dragon"))){
            return dragon();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("ice"))){
            return ice();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("psychic"))){
            return psychic();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("ghost"))){
            return ghost();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("electric"))){
            return electric();
        }else if(keccak256(abi.encode(_elemental)) == keccak256(abi.encode("unknown"))){
            return unknown();
        }else{
            return normal();
        }
    }

    function water() public view returns(string[4][5] memory){
        return cWater;
    }
    function normal() public view returns(string[4][5] memory){
        return cNormal;
    }
    function grass() public view returns(string[4][5] memory){
        return cGrass;
    }
    function rock() public view returns(string[4][5] memory){
        return cRock;
    }
    function ground() public view returns(string[4][5] memory){
        return cGround;
    }
    function bug() public view returns(string[4][5] memory){
        return cBug;
    }
    function fire() public view returns(string[4][5] memory){
        return cFire;
    }
    function poison() public view returns(string[4][5] memory){
        return cPoison;
    }
    function fighting() public view returns(string[4][5] memory){
        return cFighting;
    }
    function flying() public view returns(string[4][5] memory){
        return cFlying;
    }
    function dragon() public view returns(string[4][5] memory){
        return cDragon;
    }
    function ice() public view returns(string[4][5] memory){
        return cIce;
    }
    function psychic() public view returns(string[4][5] memory){
        return cPsychic;
    }
    function ghost() public view returns(string[4][5] memory){
        return cGhost;
    }
    function electric() public view returns(string[4][5] memory){
        return cElectric;
    }
    function unknown() public view returns(string[4][5] memory){
        return cUnknown;
    }
    
}