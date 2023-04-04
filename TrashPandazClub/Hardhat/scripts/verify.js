const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
async function main() {

// Verify the contract after deploying
await hre.run("verify:verify", {
address: "0x09D9F6CbB4E2981449361738a214D5E07226637D",
constructorArguments: ['0xe5c52C7B1ED7fa75aceB898a09f0508D26eC0533'],
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