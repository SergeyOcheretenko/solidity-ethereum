// import { describe, beforeEach } from 'mocha';
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Payments', () => {
  let contract;
  let account1;
  let account2;

  beforeEach(async () => {
    [account1, account2] = await ethers.getSigners();
    const Payments = await ethers.getContractFactory('Payments', account1);

    contract = await Payments.deploy();
    await contract.waitForDeployment();
  });

  it('should be deployed', async () => {
    const address = await contract.getAddress();
    expect(address).to.be.properAddress;
  });

  it('should have 0 ether after deployment', async () => {
    const balance = await contract.currentBalance();
    expect(balance).to.equal(0);
  });

  it('should be possible to send the funds to the contract', async () => {
    const amount = 100;
    const message = 'Test transaction';

    const tx = await contract.connect(account2).pay(message, { value: amount });
    await tx.wait();

    await expect(() => tx).to.changeEtherBalance(account2, -amount);
    await expect(() => tx).to.changeEtherBalance(contract, amount);

    const balance = await contract.currentBalance();
    expect(balance).to.equal(amount);

    const payment = await contract.getPayment(account2.address, 0);
    expect(payment.message).to.equal(message);
    expect(payment.amount).to.equal(amount);
    expect(payment.from).to.equal(account2.address);
  });
});
