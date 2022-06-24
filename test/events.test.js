// /*
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Events', function () {
  let owner;
  let other_addr;
  let evt;

  beforeEach(async function () {
    [owner, other_addr] = await ethers.getSigners();

    const EventContract = await ethers.getContractFactory('Events', owner);
    evt = await EventContract.deploy();
    await evt.deployed();
  });

  async function sendMoney(sender) {
    const amount = 100;
    const txData = {
      to: evt.address,
      value: amount,
    };

    const tx = await sender.sendTransaction(txData);
    await tx.wait();
    return [tx, amount];
  }

  it('should allow to send money', async function () {
    const [sendMoneyTx, amount] = await sendMoney(other_addr);

    console.log('sendMoneyTx:', sendMoneyTx);

    await expect(() => sendMoneyTx).to.changeEtherBalance(evt, amount);

    const timestamp = (await ethers.provider.getBlock(sendMoneyTx.blockNumber))
      .timestamp;

    await expect(sendMoneyTx)
      .to.emit(evt, 'Paid')
      .withArgs(other_addr.address, amount, timestamp);
  });

  it('should allow owner to withdraw funds', async function () {
    const [_, amount] = await sendMoney(other_addr);

    const tx = await evt.withdraw(owner.address);

    await expect(() => tx).to.changeEtherBalances(
      [evt, owner],
      [-amount, amount]
    );
  });

  it('should not allow other accounts to withdraw funds', async function () {
    await sendMoney(other_addr);

    await expect(
      evt.connect(other_addr).withdraw(other_addr.address)
    ).to.be.revertedWith('you are not an owner!');
  });
});
// */

// https://youtu.be/ZzK15vkO38c
