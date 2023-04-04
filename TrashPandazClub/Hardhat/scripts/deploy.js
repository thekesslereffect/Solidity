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
  const _gwei = 120 // https://polygonscan.com/gastracker
  var _gas = _gwei * 1000000000; 

  //deploy libraries and add to main contract
  // const gen3ImageLib1 = await hre.ethers.getContractFactory("Gen3ImageLib1");
  // const contractLib1 = await gen3ImageLib1.deploy({gasPrice: _gas}); 
  // await contractLib1.deployed();
  // console.log("Library1 Deployed Succesfully! : ", contractLib1.address); 

  // const gen3ImageLib2 = await hre.ethers.getContractFactory("Gen3ImageLib2");
  // const contractLib2 = await gen3ImageLib2.deploy({gasPrice: _gas});
  // await contractLib2.deployed();
  // console.log("Library2 Deployed Succesfully! : ", contractLib2.address); 

  const gen3 = await hre.ethers.getContractFactory("Gen3Token");
  const contract = await gen3.deploy('0xe5c52C7B1ED7fa75aceB898a09f0508D26eC0533','0x09D9F6CbB4E2981449361738a214D5E07226637D',{gasPrice: _gas}); 
  await contract.deployed();
  console.log("Contract Deployed Succesfully! : ", contract.address); 


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
