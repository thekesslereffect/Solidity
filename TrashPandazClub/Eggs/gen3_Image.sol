// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/utils/Base64.sol";


contract gen3_Image{

    function getImage(uint _seed, string[5] memory _color, string memory _chromosome) public pure returns(string memory) {
        string memory _result = TPCGen3_Image1.generateCharacter(_color[0],_color[1],_color[2],_color[3],_color[4]);
        _result = TPCGen3_Image2.generateCharacter(_result, _color[0],_color[1],_color[2],_color[3],_color[4],_chromosome);
        return _result;
    }
    function getImageCustom(string memory _chromosome, string[5] memory _color) public pure returns(string memory) {
        string memory _result = TPCGen3_Image1.generateCharacter(_color[0],_color[1],_color[2],_color[3],_color[4]);
        _result = TPCGen3_Image2.generateCharacter(_result, _color[0],_color[1],_color[2],_color[3],_color[4],_chromosome);
        return _result;
    }

}


library TPCGen3_Image1 {
    function generateCharacter(string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5 ) public pure returns(string memory){
        // stack too deep so we need to split this bitch up
        string memory result = "";
        {
            result = string(abi.encodePacked(
                '<svg width="128" height="128" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://boxy-svg.com" shape-rendering="crispEdges">',
                '<rect x="8" y="0" width="8" height="8" fill=',_color2,'/>',
                '<rect x="16" y="0" width="16" height="8" fill=',_color4,'/>',
                '<rect x="32" y="0" width="64" height="8" fill=',_color2,'/>',
                '<rect x="96" y="0" width="16" height="8" fill=',_color4,'/>',
                '<rect x="112" y="0" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="8" y="8" width="8" height="8" fill=',_color4,'/>',
                '<rect x="16" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="24" y="8" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="8" width="16" height="8" fill=',_color4,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="48" y="8" width="32" height="8" fill=',_color3,'/>',
                '<rect x="80" y="8" width="16" height="8" fill=',_color4,'/>',
                '<rect x="96" y="8" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="112" y="8" width="8" height="8" fill=',_color4,'/>',
                '<rect x="120" y="8" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="8" y="16" width="8" height="8" fill=',_color4,'/>',
                '<rect x="16" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="24" y="16" width="24" height="8" fill=',_color4,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="48" y="16" width="32" height="8" fill=',_color3,'/>',
                '<rect x="80" y="16" width="24" height="8" fill=',_color4,'/>',
                '<rect x="104" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="112" y="16" width="8" height="8" fill=',_color4,'/>',
                '<rect x="120" y="16" width="8" height="8" fill=',_color3,'/>',
                '<rect x="0" y="24" width="8" height="8" fill=',_color3,'/>',
                '<rect x="8" y="24" width="24" height="8" fill=',_color4,'/>',
                '<rect x="32" y="24" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="24" width="16" height="8" fill=',_color4,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="56" y="24" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="24" width="16" height="8" fill=',_color4,'/>',
                '<rect x="88" y="24" width="8" height="8" fill=',_color5,'/>',
                '<rect x="96" y="24" width="24" height="8" fill=',_color4,'/>',
                '<rect x="120" y="24" width="8" height="8" fill=',_color3,'/>',
                '<rect x="0" y="32" width="8" height="8" fill=',_color2,'/>',
                '<rect x="8" y="32" width="32" height="8" fill=',_color4,'/>',
                '<rect x="40" y="32" width="8" height="8" fill=',_color5,'/>',
                '<rect x="48" y="32" width="8" height="8" fill=',_color4,'/>'
                
            ));

        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="56" y="32" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="32" width="8" height="8" fill=',_color4,'/>',
                '<rect x="80" y="32" width="8" height="8" fill=',_color5,'/>',
                '<rect x="88" y="32" width="32" height="8" fill=',_color4,'/>',
                '<rect x="120" y="32" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="40" width="8" height="8" fill=',_color2,'/>',
                '<rect x="8" y="40" width="16" height="8" fill=',_color4,'/>',
                '<rect x="24" y="40" width="32" height="8" fill=',_color5,'/>',
                '<rect x="56" y="40" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="40" width="32" height="8" fill=',_color5,'/>'
                
            ));        
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="104" y="40" width="16" height="8" fill=',_color4,'/>',
                '<rect x="120" y="40" width="8" height="8" fill=',_color2,'/>',
                '<rect x="0" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="16" y="48" width="8" height="8" fill=',_color5,'/>'
                '<rect x="24" y="48" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="48" y="48" width="32" height="8" fill=',_color3,'/>'
                
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="80" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="96" y="48" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="48" width="8" height="8" fill=',_color5,'/>',
                '<rect x="112" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="0" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="16" y="56" width="8" height="8" fill=',_color3,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="24" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="48" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="56" y="56" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="80" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="88" y="56" width="8" height="8" fill=',_color5,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="96" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="112" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="120" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="0" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="16" y="48" width="8" height="8" fill=',_color5,'/>',
                '<rect x="24" y="48" width="8" height="8" fill=',_color3,'/>'
                
            ));

        }     
        return result;
    }
}

library TPCGen3_Image2 {
    function generateCharacter(string memory _result, string memory _color1, string memory _color2, string memory _color3, string memory _color4, string memory _color5, string memory _chromosome ) public pure returns(string memory){
        if (keccak256(abi.encodePacked(_chromosome)) == keccak256(abi.encodePacked("XX")) ){
            _chromosome = _color1;
        }else{
            _chromosome = _color3;
        }

        string memory result = _result;
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="32" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="48" y="48" width="32" height="8" fill=',_color3,'/>',
                '<rect x="80" y="48" width="16" height="8" fill=',_color1,'/>',
                '<rect x="96" y="48" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="48" width="8" height="8" fill=',_color5,'/>',
                '<rect x="112" y="48" width="16" height="8" fill=',_color4,'/>',
                '<rect x="0" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="16" y="56" width="8" height="8" fill=',_color3,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="24" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="48" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="56" y="56" width="16" height="8" fill=',_color3,'/>',
                '<rect x="72" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="80" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="88" y="56" width="8" height="8" fill=',_color5,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="96" y="56" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="56" width="8" height="8" fill=',_color3,'/>',
                '<rect x="112" y="56" width="8" height="8" fill=',_color5,'/>',
                '<rect x="120" y="56" width="8" height="8" fill=',_color4,'/>',
                '<rect x="0" y="64" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="64" width="16" height="8" fill=',_chromosome,'/>',
                '<rect x="24" y="64" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="64" width="8" height="8" fill=',_color5,'/>',
                '<rect x="40" y="64" width="8" height="8" fill=',_color3,'/>',
                '<rect x="48" y="64" width="8" height="8" fill=',_color5,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="56" y="64" width="16" height="8" fill=',_color4,'/>',
                '<rect x="72" y="64" width="8" height="8" fill=',_color5,'/>',
                '<rect x="80" y="64" width="8" height="8" fill=',_color3,'/>',
                '<rect x="88" y="64" width="8" height="8" fill=',_color5,'/>',
                '<rect x="96" y="64" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="64" width="16" height="8" fill=',_chromosome,'/>',
                '<rect x="120" y="64" width="8" height="8" fill=',_color4,'/>',
                '<rect x="8" y="72" width="8" height="8" fill=',_color5,'/>',
                '<rect x="16" y="72" width="24" height="8" fill=',_color3,'/>',
                '<rect x="40" y="72" width="48" height="8" fill=',_color5,'/>'
                
                  
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="88" y="72" width="24" height="8" fill=',_color3,'/>',
                '<rect x="112" y="72" width="8" height="8" fill=',_color5,'/>',
                '<rect x="8" y="80" width="8" height="8" fill=',_color1,'/>',
                '<rect x="16" y="80" width="96" height="8" fill=',_color5,'/>',
                '<rect x="112" y="80" width="8" height="8" fill=',_color1,'/>'                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="0" y="88" width="8" height="8" fill=',_color1,'/>',
                '<rect x="8" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="16" y="88" width="16" height="8" fill=',_color2,'/>',
                '<rect x="32" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="40" y="88" width="8" height="8" fill=',_color5,'/>',
                '<rect x="48" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="56" y="88" width="8" height="8" fill=',_color5,'/>',
                '<rect x="64" y="88" width="16" height="8" fill=',_color4,'/>',
                '<rect x="80" y="88" width="8" height="8" fill=',_color5,'/>',
                '<rect x="88" y="88" width="8" height="8" fill=',_color4,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="96" y="88" width="16" height="8" fill=',_color2,'/>',
                '<rect x="112" y="88" width="8" height="8" fill=',_color4,'/>',
                '<rect x="120" y="88" width="8" height="8" fill=',_color1,'/>',
                '<rect x="0" y="96" width="8" height="8" fill=',_color1,'/>',
                '<rect x="8" y="96" width="16" height="8" fill=',_color4,'/>',
                '<rect x="24" y="96" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="96" width="64" height="8" fill=',_color5,'/>',
              '<rect x="96" y="96" width="8" height="8" fill=',_color3,'/>',
                '<rect x="104" y="96" width="16" height="8" fill=',_color4,'/>'
                
            ));
        }
        {
            result = string(abi.encodePacked(
              result,
              '<rect x="120" y="96" width="8" height="8" fill=',_color1,'/>',
                '<rect x="8" y="104" width="16" height="8" fill=',_color1,'/>',
                '<rect x="24" y="104" width="8" height="8" fill=',_color3,'/>',
                '<rect x="32" y="104" width="16" height="8" fill=',_color4,'/>',
                '<rect x="48" y="104" width="32" height="8" fill=',_color5,'/>',
                '<rect x="80" y="104" width="16" height="8" fill=',_color4,'/>',
                '<rect x="96" y="104" width="8" height="8" fill=',_color3,'/>'
            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="104" y="104" width="16" height="8" fill=',_color1,'/>',
                '<rect x="0" y="112" width="24" height="8" fill="#0000006B"/>',
                '<rect x="24" y="112" width="8" height="8" fill=',_color1,'/>',
                '<rect x="32" y="112" width="24" height="8" fill=',_color3,'/>',
                '<rect x="56" y="112" width="16" height="8" fill=',_color1,'/>',
                '<rect x="72" y="112" width="24" height="8" fill=',_color3,'/>',
                '<rect x="96" y="112" width="8" height="8" fill=',_color1,'/>',
                '<rect x="104" y="112" width="24" height="8" fill="#0000006B"/>'

            ));
        }
        {
            result = string(abi.encodePacked(
                result,
                '<rect x="8" y="120" width="24" height="8" fill="#0000006B"/>',
                '<rect x="32" y="120" width="24" height="8" fill=',_color1,'/>',
                '<rect x="56" y="120" width="16" height="8" fill="#0000006B"/>',
                '<rect x="72" y="120" width="24" height="8" fill=',_color1,'/>',
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


    
