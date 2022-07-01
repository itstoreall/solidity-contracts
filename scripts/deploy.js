const hre = require('hardhat');
const ethers = hre.ethers;

async function main() {
  const [signer] = await ethers.getSigners();

  const Erc = await ethers.getContractFactory('UAShop', signer);
  const erc = await Erc.deploy();
  await erc.deployed();

  console.log(erc.address); // 0x5FbDB2315678afecb367f032d93F642f64180aa3
  console.log(await erc.token()); // 0xa16E02E87b7454126E5E10d957A927A7F5B5d2be
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
