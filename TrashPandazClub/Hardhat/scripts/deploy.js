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


// npx hardhat run scripts/deploy.js --network polygon

const hre = require("hardhat");
require("@nomiclabs/hardhat-etherscan");

async function main() {
  //deploy libraries and add to main contract
  const gen3_ImageLib1 = await hre.ethers.getContractFactory("gen3_ImageLib1");
  const _gen3_ImageLib1 = gen3_ImageLib1.deploy();
  await _gen3_ImageLib1.deployed();
  const gen3_ImageLib2 = await hre.ethers.getContractFactory("gen3_ImageLib2");
  const _gen3_ImageLib2 = gen3_ImageLib2.deploy();
  await _gen3_ImageLib2.deployed();

  const gen3_Image = await hre.ethers.getContractFactory("gen3_Image", {
    libraries: {
      gen3_ImageLib1: _gen3_ImageLib1.address,
      gen3_ImageLib2: _gen3_ImageLib2.address,
    },
  });

  // const _contract = await gen3_Image.deploy('0x1aAA180d4C82aa7EAcEa1FAe8B09BbB8174Cbbf0','0x24C82E859540FA03aE4681e03aC5aFCc4F7f70fE',18);
  const _contract = await gen3_Image.deploy();
  await _contract.deployed();
  console.log("Library1 Deployed Succesfully! : ", _gen3_ImageLib1.address); 
  console.log("Library2 Deployed Succesfully! : ", _gen3_ImageLib1.address); 
  console.log("Contract Deployed Succesfully! : ", _contract.address); 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
