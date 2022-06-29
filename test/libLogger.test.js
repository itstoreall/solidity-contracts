/*
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('LibLogger', function () {
  let owner;
  let demo;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    const LibDemo = await ethers.getContractFactory('LibLogger', owner);
    demo = await LibDemo.deploy();
    await demo.deployed();
  });

  it('compares string', async function () {
    const result = await demo.runnerStr('cat', 'cat');
    expect(result).to.eq(true);

    const result2 = await demo.runnerStr('cat', 'dog');
    expect(result2).to.eq(false);
  });

  it('finds uint in array', async function () {
    const result = await demo.runnerArr([1, 2, 3], 2);
    expect(result).to.eq(true);

    const result2 = await demo.runnerArr([1, 2, 3], 42);
    expect(result2).to.eq(false);
  });
});
*/

// https://youtu.be/LHtNg30nNgA
