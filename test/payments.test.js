/*
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Payments', () => {
  let acc1;
  let acc2;
  let payments;

  beforeEach(async function () {
    [acc1, acc2] = await ethers.getSigners();
    const Payments = await ethers.getContractFactory('Payments', acc1);

    payments = await Payments.deploy(); // sends the transaction
    await payments.deployed(); // executes the transaction

    console.log('Deployed contract:', payments.address);
  });

  it('should be deployed', async () => {
    expect(payments.address).to.be.properAddress;
    console.log('success!');
  });

  it('should have 0 eth by default', async () => {
    const balance = await payments.currentBalance();
    expect(balance).to.eq(0);
    console.log('balance:', balance);
  });

  it('should be possible to send funds', async () => {
    const sum = 100;
    const message = 'hello from hardhat';
    const tx = await payments.connect(acc2).pay(message, { value: sum });

    await expect(() => tx).to.changeEtherBalances(
      [acc2, payments],
      [-sum, sum]
    );

    await tx.wait();

    const newPayment = await payments.getPayment(acc2.address, 0);

    console.log('newPayment:', newPayment);

    expect(newPayment.message).to.eq(message);
    expect(newPayment.amount).to.eq(sum);
    expect(newPayment.from).to.eq(acc2.address);
  });
});
*/
