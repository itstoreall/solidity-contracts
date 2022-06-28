require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-waffle');
require('solidity-coverage');
require('dotenv').config();

task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.4',
  // networks: {
  //   rinkeby: {
  //     url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  //   hardhat: {
  //     chainId: 1337,
  //   },
  // },
  // etherscan: {
  //   apiKey: `${procass.env.ETHERSCAN_KEY}`,
  // },
};
