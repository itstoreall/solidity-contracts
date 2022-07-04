// /*
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('StakingRewards tests:', function () {
  let owner; // 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  let staker; // 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
  let token; // 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
  let stakeContract;

  beforeEach(async function () {
    [owner, token, staker] = await ethers.getSigners();

    const StakingRewards = await ethers.getContractFactory(
      'StakingRewards',
      owner
    );

    stakeContract = await StakingRewards.deploy(token.address, 52);

    await stakeContract.deployed(token.address, 52);
  });

  it('Checking the owner, token and some functions', async function () {
    const contractOwner = await stakeContract.owner();
    const contractToken = await stakeContract.token();
    const stakerBalance = await stakeContract.balanceOf(staker.address);
    const totalSupply = await stakeContract.totalSupply();
    const earned = await stakeContract.earned(contractOwner);

    console.log('owner:', contractOwner);
    console.log('token:', contractToken);
    console.log('stakerBalance', stakerBalance.toNumber());
    console.log('totalSupply', totalSupply.toNumber());
    console.log('earned', earned.toNumber());

    expect(await contractOwner).to.eq(owner.address);
    expect(await contractToken).to.be.properAddress;
  });
});
// */
