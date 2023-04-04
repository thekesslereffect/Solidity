// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/utils/Base64.sol";

library Gen3ImageLib2 {
    function generateCharacter(string memory _result, string memory _color1, string memory _color3, string memory _color4, string memory _color5, string memory _chromosome ) external pure returns(string memory){
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