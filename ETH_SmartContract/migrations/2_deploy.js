const BBSEToken = artifacts.require("BBSEToken");
const BBSEBank = artifacts.require("BBSEBank");

module.exports = async function (deployer) {
  // Deploy BBSEToken
  await deployer.deploy(BBSEToken);
  const bbseToken = await BBSEToken.deployed();

  // Deploy BBSEBank with BBSEToken contract's address
  // and a yearly return rate of 10
  await deployer.deploy(BBSEBank, bbseToken.address, 10);
  const bbseBank = await BBSEBank.deployed();

  // Pass the minter role in BBSEToken to BBSEBank
  await bbseToken.passMinterRole(bbseBank.address);
};
