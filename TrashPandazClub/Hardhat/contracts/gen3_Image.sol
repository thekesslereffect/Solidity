// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/utils/Base64.sol";

library gen3_ImageLib1 {
    function generateCharacter(string memory _color1, string memory _color3, string memory _color4, string memory _color5 ) public pure returns(string memory){
        // stack too deep so we need to split this bitch up
        string memory result = "";
        {
            result = string(abi.encodePacked(
                '<svg width="128" height="128" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://boxy-svg.com" shape-rendering="crispEdges">',
                '<rect x="8" y="0" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="16" y="0" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="32" y="0" width="64" height="8" fill="',_color1,'"/>',
                '<rect x="96" y="0" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="112" y="0" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="0" y="8" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="8" y="8" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="16" y="8" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="24" y="8" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="32" y="8" width="16" height="8" fill="',_color4,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="48" y="8" width="32" height="8" fill="',_color3,'"/>',
                '<rect x="80" y="8" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="96" y="8" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="104" y="8" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="112" y="8" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="120" y="8" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="0" y="16" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="8" y="16" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="16" y="16" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="24" y="16" width="24" height="8" fill="',_color4,'"/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="48" y="16" width="32" height="8" fill="',_color3,'"/>',
                '<rect x="80" y="16" width="24" height="8" fill="',_color4,'"/>',
                '<rect x="104" y="16" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="112" y="16" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="120" y="16" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="0" y="24" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="8" y="24" width="24" height="8" fill="',_color4,'"/>',
                '<rect x="32" y="24" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="40" y="24" width="16" height="8" fill="',_color4,'"/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="56" y="24" width="16" height="8" fill="',_color3,'"/>',
                '<rect x="72" y="24" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="88" y="24" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="96" y="24" width="24" height="8" fill="',_color4,'"/>',
                '<rect x="120" y="24" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="0" y="32" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="8" y="32" width="32" height="8" fill="',_color4,'"/>',
                '<rect x="40" y="32" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="48" y="32" width="8" height="8" fill="',_color4,'"/>'
                
            ));

        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="56" y="32" width="16" height="8" fill="',_color3,'"/>',
                '<rect x="72" y="32" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="80" y="32" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="88" y="32" width="32" height="8" fill="',_color4,'"/>',
                '<rect x="120" y="32" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="0" y="40" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="8" y="40" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="24" y="40" width="32" height="8" fill="',_color5,'"/>',
                '<rect x="56" y="40" width="16" height="8" fill="',_color3,'"/>',
                '<rect x="72" y="40" width="32" height="8" fill="',_color5,'"/>'
                
            ));        
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="104" y="40" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="120" y="40" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="0" y="48" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="16" y="48" width="8" height="8" fill="',_color5,'"/>'
                '<rect x="24" y="48" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="32" y="48" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="48" y="48" width="32" height="8" fill="',_color3,'"/>'
                
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="80" y="48" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="96" y="48" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="104" y="48" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="112" y="48" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="0" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="8" y="56" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="16" y="56" width="8" height="8" fill="',_color3,'"/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="24" y="56" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="32" y="56" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="40" y="56" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="48" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="56" y="56" width="16" height="8" fill="',_color3,'"/>',
                '<rect x="72" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="80" y="56" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="88" y="56" width="8" height="8" fill="',_color5,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="96" y="56" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="104" y="56" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="112" y="56" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="120" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="0" y="48" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="16" y="48" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="24" y="48" width="8" height="8" fill="',_color3,'"/>'
                
            ));

        }     
        return result;
    }
}

library gen3_ImageLib2 {
    function generateCharacter(string memory _result, string memory _color1, string memory _color3, string memory _color4, string memory _color5, string memory _chromosome ) public pure returns(string memory){
        if (keccak256(abi.encodePacked(_chromosome)) == keccak256(abi.encodePacked("XX")) ){
            _chromosome = _color1;
        }else{
            _chromosome = _color3;
        }

        string memory result = _result;
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="32" y="48" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="48" y="48" width="32" height="8" fill="',_color3,'"/>',
                '<rect x="80" y="48" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="96" y="48" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="104" y="48" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="112" y="48" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="0" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="8" y="56" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="16" y="56" width="8" height="8" fill="',_color3,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="24" y="56" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="32" y="56" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="40" y="56" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="48" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="56" y="56" width="16" height="8" fill="',_color3,'"/>',
                '<rect x="72" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="80" y="56" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="88" y="56" width="8" height="8" fill="',_color5,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="96" y="56" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="104" y="56" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="112" y="56" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="120" y="56" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="0" y="64" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="8" y="64" width="16" height="8" fill="',_chromosome,'"/>',
                '<rect x="24" y="64" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="32" y="64" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="40" y="64" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="48" y="64" width="8" height="8" fill="',_color5,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="56" y="64" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="72" y="64" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="80" y="64" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="88" y="64" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="96" y="64" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="104" y="64" width="16" height="8" fill="',_chromosome,'"/>',
                '<rect x="120" y="64" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="8" y="72" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="16" y="72" width="24" height="8" fill="',_color3,'"/>',
                '<rect x="40" y="72" width="48" height="8" fill="',_color5,'"/>'
                
                  
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="88" y="72" width="24" height="8" fill="',_color3,'"/>',
                '<rect x="112" y="72" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="8" y="80" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="16" y="80" width="96" height="8" fill="',_color5,'"/>',
                '<rect x="112" y="80" width="8" height="8" fill="',_color1,'"/>'                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="0" y="88" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="8" y="88" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="16" y="88" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="32" y="88" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="40" y="88" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="48" y="88" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="56" y="88" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="64" y="88" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="80" y="88" width="8" height="8" fill="',_color5,'"/>',
                '<rect x="88" y="88" width="8" height="8" fill="',_color4,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="96" y="88" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="112" y="88" width="8" height="8" fill="',_color4,'"/>',
                '<rect x="120" y="88" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="0" y="96" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="8" y="96" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="24" y="96" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="32" y="96" width="64" height="8" fill="',_color5,'"/>',
              '<rect x="96" y="96" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="104" y="96" width="16" height="8" fill="',_color4,'"/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="120" y="96" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="8" y="104" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="24" y="104" width="8" height="8" fill="',_color3,'"/>',
                '<rect x="32" y="104" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="48" y="104" width="32" height="8" fill="',_color5,'"/>',
                '<rect x="80" y="104" width="16" height="8" fill="',_color4,'"/>',
                '<rect x="96" y="104" width="8" height="8" fill="',_color3,'"/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="104" y="104" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="0" y="112" width="24" height="8" fill="#0000006B"/>',
                '<rect x="24" y="112" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="32" y="112" width="24" height="8" fill="',_color3,'"/>',
                '<rect x="56" y="112" width="16" height="8" fill="',_color1,'"/>',
                '<rect x="72" y="112" width="24" height="8" fill="',_color3,'"/>',
                '<rect x="96" y="112" width="8" height="8" fill="',_color1,'"/>',
                '<rect x="104" y="112" width="24" height="8" fill="#0000006B"/>'

            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="8" y="120" width="24" height="8" fill="#0000006B"/>',
                '<rect x="32" y="120" width="24" height="8" fill="',_color1,'"/>',
                '<rect x="56" y="120" width="16" height="8" fill="#0000006B"/>',
                '<rect x="72" y="120" width="24" height="8" fill="',_color1,'"/>',
                '<rect x="96" y="120" width="24" height="8" fill="#0000006B"/>',
                '</svg>'
            ));
        }


        bytes memory svg = abi.encodePacked(result);
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }
}

contract gen3_Image{

    function getImage(string[4] memory _color, string memory _chromosome, bool _mutated) external view returns(string memory) {
        string memory _result = gen3_ImageLib1.generateCharacter(_color[0],_color[1],_color[2],_color[3]);
        _result = gen3_ImageLib2.generateCharacter(_result, _color[0],_color[1],_color[2],_color[3],_chromosome);
        return _result;
    }


    /// COLOR

    string[4][4] cWater = [ 
        ["#48314b","#382a52","#4c3040","#39293a"],
        ["#51577b","#467086","#5c477d","#7c649b"],
        ["#638fb1","#4fc5bc","#5f62b5","#01bbdb"],
        ["#dddcc3","#e4cebc","#eaf2e3","#e3d77b"]
    ]; 
    string[4][4] cNormal = [
        ["#1f2f30","#1a3528","#1e2631","#293031"],
        ["#5b7669","#547d54","#487476","#aebfa8"],
        ["#aebfb1","#b2c4a9","#9ec0b6","#5b7375"],
        ["#e4efe9","#e2f2e1","#ecf8f7","#ebe7b5"]
    ]; 
    string[4][4] cGrass = [
        ["#31433d","#2c4830","#2d3b47","#332e51"],
        ["#40644f","#3c6e36","#2d5f6b","#228573"],
        ["#90b66f","#c6c85d","#5ec780","#8dc95e"],
        ["#dbeeca","#f7f8c0","#f7f0e9","#e6edb4"]
    ];
    string[4][4] cRock = [
        ["#3d343b","#3b323f","#3d3436","#1e2742"],
        ["#6b4859","#734073","#794441","#873661"],
        ["#7f8a8f","#7c938f","#70758e","#657278"],
        ["#e3e0d3","#e7d6d0","#edf2e3","#d4a86e"]
    ];
    string[4][4] cGround = [
        ["#373131","#392f34","#373431","#402624"],
        ["#6b5045","#753b49","#6b685a","#854631"],
        ["#9c816a","#a95d61","#9f9e67","#615c4f"],
        ["#d1d7bb","#ded2b4","#d6f0ce","#edb33e"]
    ];
    // Rare bug,fire,poison,fighting,flying
    string[4][4] cBug = [
        ["#4f4355","#474256","#584054","#512574"],
        ["#6d5e94","#555e9d","#8e499e","#a400bd"],
        ["#ed8cdf","#e586f3","#fa7fa7","#ff08a4"],
        ["#e7eddd","#eeeddc","#deefdb","#ffd633"]
    ];
    string[4][4] cFire = [
        ["#4b4658","#454859","#4e4559","#3c3362"],
        ["#c5485a","#cd408f","#c94544","#d63c60"],
        ["#e9b463","#f1775b","#edca5f","#6ac7ce"],
        ["#f7ecc4","#fad6c1","#f9f8e5","#f4d289"]
    ];
    string[4][4] cPoison = [
        ["#473f52","#3e3e53","#503b56","#290f33"],
        ["#724885","#574489","#8f3e8c","#a137ed"],
        ["#9c7fb1","#857cb4","#b171c0","#da43ff"],
        ["#d9debf","#e0d7bd","#ccff9c","#92ed37"]
    ];
    string[4][4] cFighting = [
        ["#483340","#4a2f4c","#49323d","#1e141a"],
        ["#534e6b","#485371","#5a4b79","#2f2136"],
        ["#98627a","#a2589a","#9a4861","#551737"],
        ["#eddce2","#f0d9ec","#fef2f4","#a6336a"]
    ];
    string[4][4] cFlying = [
        ["#3f3b37","#3f3737","#3f3c37","#4a195c"],
        ["#4b5e5d","#3a624a","#3b5b5e","#555c82"],
        ["#bf7753","#c54d57","#c28750","#e76c58"],
        ["#d6d6d6","#deb5aa","#fbefef","#6dddbd"]
    ];
    // Legendary dragon,ice,psychic,ghost,electric
    string[4][4] cDragon = [
        ["#443546","#403546","#463541","#210f1a"],
        ["#a8516a","#b13f79","#aa5842","#342447"],
        ["#87beed","#86d4ee","#8794ed","#a83a6a"],
        ["#e4f4f2","#e4f4ef","#e4f0f4","#00aae8"]
    ];
    string[4][4] cIce = [
        ["#316c83","#317e83","#315c83","#141930"],
        ["#489eba","#47b7bb","#6595ba","#d4f8ff"],
        ["#41e7e2","#40e8be","#9fd6e9","#0ba9b8"],
        ["#ecf2d2","#f2f1d2","#e6f2d2","#1edfe6"]
    ];
    string[4][4] cPsychic = [
        ["#403737","#40373b","#403937","#3118ad"],
        ["#e960b6","#e35eeb","#e9609b","#edd537"],
        ["#2dbed7","#2adaa7","#2d9cd7","#ff14e8"],
        ["#f8d766","#fa9664","#f8f466","#18d8ed"]
    ];
    string[4][4] cGhost = [
        ["#cc5bb7","#995acd","#ea5eb3","#00bbff"],
        ["#6e3fa1","#3f4ea1","#9a2ccc","#ec17ff"],
        ["#3f3546","#353646","#4c3652","#3f264d"],
        ["#cfd0ea","#cfe1ea","#f1f0fa","#6d27ab"]
    ];
    string[4][4] cElectric = [
        ["#4c3848","#5b4353","#4a3a43","#363340"],
        ["#b6722f","#d09942","#a88f3d","#ffd900"],
        ["#f7b82d","#fbdd64","#e2db42","#575f7d"],
        ["#f9eec8","#ffffff","#f2f4cd","#37eded"]
    ];
    string[4][4] cUnknown = [
        ["#2b2c30","#2b2c30","#2b2c30","#2b2c30"],
        ["#323645","#323645","#323645","#323645"],
        ["#5f6585","#5f6585","#5f6585","#5f6585"],
        ["#e7d4ad","#e7d4ad","#e7d4ad","#e7d4ad"]
    ];


    // Common water,normal,grass,rock,ground
    // Rare bug,fire,poison,fighting,flying
    // Legendary dragon,ice,psychic,ghost,electric
    function getColor(string memory _elemental) external view returns(string[4][4] memory color){
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

    function getMutationColor() external view returns(string[4][4][15] memory){
        string[4][4][15] memory mutationColor;
        mutationColor = [water(),normal(),grass(),rock(),ground(),bug(),fire(),poison(),fighting(),flying(),dragon(),ice(),psychic(),ghost(),electric()];
        return mutationColor;
    }

    function water() public view returns(string[4][4] memory){
        return cWater;
    }
    function normal() public view returns(string[4][4] memory){
        return cNormal;
    }
    function grass() public view returns(string[4][4] memory){
        return cGrass;
    }
    function rock() public view returns(string[4][4] memory){
        return cRock;
    }
    function ground() public view returns(string[4][4] memory){
        return cGround;
    }
    function bug() public view returns(string[4][4] memory){
        return cBug;
    }
    function fire() public view returns(string[4][4] memory){
        return cFire;
    }
    function poison() public view returns(string[4][4] memory){
        return cPoison;
    }
    function fighting() public view returns(string[4][4] memory){
        return cFighting;
    }
    function flying() public view returns(string[4][4] memory){
        return cFlying;
    }
    function dragon() public view returns(string[4][4] memory){
        return cDragon;
    }
    function ice() public view returns(string[4][4] memory){
        return cIce;
    }
    function psychic() public view returns(string[4][4] memory){
        return cPsychic;
    }
    function ghost() public view returns(string[4][4] memory){
        return cGhost;
    }
    function electric() public view returns(string[4][4] memory){
        return cElectric;
    }
    function unknown() public view returns(string[4][4] memory){
        return cUnknown;
    }

}