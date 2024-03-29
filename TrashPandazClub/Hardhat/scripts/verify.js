const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
async function main() {

// Verify the contract after deploying
await hre.run("verify:verify", {
address: "0x693e5090A03c9D8d0a1D262e3D78eD07b521bcaE",
constructorArguments: ['0x75CfC337076a1CF907a00a0D60B21bC6e2c4FD1c','0x24C82E859540FA03aE4681e03aC5aFCc4F7f70fE'],
});
}
// Call the main function and catch if there is any error
main()
.then(() => process.exit(0))
.catch((error) => {
console.error(error);
process.exit(1);
});

// const { ethers } = require("hardhat");
// require("dotenv").config({ path: ".env" });
// require("@nomiclabs/hardhat-etherscan");
// async function main() {

// // Verify the contract after deploying
// await hre.run("verify:verify", {
// address: "0xB8049675e27F9f7CA7c80087BC0D8E82e45e14aF",
// constructorArguments: ['0xFcD5C25C64f822F5b3a16CEfd1F98783E04Db4c4','0x24C82E859540FA03aE4681e03aC5aFCc4F7f70fE','0x1aAA180d4C82aa7EAcEa1FAe8B09BbB8174Cbbf0', '0x9963bc674e7D9c5259d5E0Bf1094d8D353f5dAA1'],
// });
// }
// // Call the main function and catch if there is any error
// main()
// .then(() => process.exit(0))
// .catch((error) => {
// console.error(error);
// process.exit(1);
// });