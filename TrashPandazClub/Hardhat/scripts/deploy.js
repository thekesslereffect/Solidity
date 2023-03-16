// const hre = require("hardhat");
// require("@nomiclabs/hardhat-etherscan");

// async function main() {
//   const TrashSwap = await hre.ethers.getContractFactory("TrashSwap");
//   const trashSwap = await TrashSwap.deploy('0xFcD5C25C64f822F5b3a16CEfd1F98783E04Db4c4','0x24C82E859540FA03aE4681e03aC5aFCc4F7f70fE','0x1aAA180d4C82aa7EAcEa1FAe8B09BbB8174Cbbf0', '0x9963bc674e7D9c5259d5E0Bf1094d8D353f5dAA1');

//   await trashSwap.deployed();

//   console.log("Contract Deployed Succesfully! : ", trashSwap.address); 
// }

// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });

const hre = require("hardhat");
require("@nomiclabs/hardhat-etherscan");

async function main() {
  const GhostStaking = await hre.ethers.getContractFactory("GhostStaking");
  const ghost = await GhostStaking.deploy('0x1aAA180d4C82aa7EAcEa1FAe8B09BbB8174Cbbf0','0x24C82E859540FA03aE4681e03aC5aFCc4F7f70fE',18);

  await ghost.deployed();

  console.log("Contract Deployed Succesfully! : ", ghost.address); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
