require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  defaultNetwork:"polygon",
  networks:{
    polygon:{
      url:process.env.ALCHEMY_MAINNET_API_KEY,
      accounts:[process.env.PRIVATE_KEY]
    },
    // mumbai:{
    //   url:process.env.ALCHEMY_MUMBAI_API_KEY,
    //   accounts:[process.env.PRIVATE_KEY]
    // }
  },
  etherscan:{
    apiKey:{
      polygon:process.env.POLYGONSCAN_API_KEY
    }
  },
  customChains: [
    {
      network: "polygon",
      chainId: 137,
      urls:{
        apiURL: "https://api.polygonscan.com/",
        browserURL: "https://polygonscan.com/"
      }
    }
  ]
};


