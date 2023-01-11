pragma solidity ^0.6.0;

contract BlackAndWhiteSquares {
  // Generate an SVG image of black and white squares
  function generateSVG() public pure returns (string memory) {
    // Set the dimensions of the image
    uint width = 500;
    uint height = 500;

    // Set the size of the squares
    uint squareSize = 50;

    // Initialize the SVG string
    string memory svg = "<svg width='" + width + "' height='" + height + "'>";

    // Generate the black and white squares
    for (uint y = 0; y < height; y += squareSize) {
      for (uint x = 0; x < width; x += squareSize) {
        // Determine the color of the square
        string memory color = (x + y) % (2 * squareSize) < squareSize ? "black" : "white";

        // Add the square to the SVG string
        svg += "<rect x='" + x + "' y='" + y + "' width='" + squareSize + "' height='" + squareSize + "' fill='" + color + "' />";
      }
    }

    // Close the SVG tag
    svg += "</svg>";

    // Return the SVG string
    return svg;
  }
}