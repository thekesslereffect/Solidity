
// pixelArray=
//     [1,5,3,3,5,5,5,5,5,5,5,5,3,3,5,1,
//     5,3,5,4,3,3,4,4,4,4,3,3,4,5,3,5,
//     4,3,4,3,3,3,4,4,4,4,3,3,3,4,3,4,
//     4,3,3,3,2,3,3,4,4,3,3,2,3,3,3,4,
//     5,3,3,3,3,2,3,4,4,3,2,3,3,3,3,5,
//     5,3,3,2,2,2,2,4,4,2,2,2,2,3,3,5,
//     3,3,2,4,6,6,4,4,4,4,6,6,4,2,3,3,
//     3,2,4,6,2,4,3,4,4,3,4,2,6,4,2,3,
//     3,4,4,6,2,4,2,3,3,2,4,2,6,4,4,3, //row 8 column 3 and 24
//     1,2,4,4,4,2,2,2,2,2,2,4,4,4,2,1,
//     1,6,2,2,2,2,2,2,2,2,2,2,2,2,6,1,
//     6,3,5,5,3,2,3,2,3,3,2,3,5,5,3,6,
//     6,3,3,4,2,2,2,2,2,2,2,2,4,3,3,6,
//     1,6,6,4,3,3,2,2,2,2,3,3,4,6,6,1,
//     7,7,7,6,4,4,4,6,6,4,4,4,6,7,7,7, // 7 is shadow color
//     1,7,7,7,6,6,6,7,7,6,6,6,7,7,7,1];

// finalImage="";
    
// function mint() {
//     generateSVG();
//     console.log(finalImage);
// }

// function generateSVG() {
//     let svgBytes = `<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" shape-rendering="crispEdges">`;
//     for (let i = 0; i < 256; i++) {
//         row = Math.floor(i / 16)*8;
//         col = Math.floor(i % 16)*8;
//         let _color = getColor(pixelArray[i]);
//         svgBytes += `<rect x="`+col+`" y="`+row+`" width="8" height="8" fill="`+_color+`"/>`;
//     }
//     svgBytes += "</svg>";
//     let base64String = btoa(svgBytes);
//     finalImage = "data:image/svg+xml;base64,"+base64String;
// }


// function getColor(_pixelValue){
//     if (_pixelValue == 1) {
//         return "#00000000"; // Transparent
//     } else if (_pixelValue == 2) {
//         return "#aaaaaa"; // Light grey
//     } else if (_pixelValue == 3) {
//         return "#888888"; // Grey
//     } else if (_pixelValue == 4) {
//         return "#666666"; // Dark grey
//     } else if (_pixelValue == 5) {
//         return "#444444"; // Very dark grey
//     } else if (_pixelValue == 6) {
//         return "#222222"; // Almost black
//     } else {
//         return "#000000"; // Black
//     }
// }

// mint();

const check = ["1","2","3"];
const loops = 10;
function test(){
    for (let index = 0; index < loops; index++) {
        let _rand = Math.floor(Math.random() * check.length);
        let _sel = check[_rand];
        console.log(_sel);
    }
}
test();