const hre = require("hardhat");
const { TIME_VAULT_LOCK_TOKEN_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  const tvltokenAddress= TIME_VAULT_LOCK_TOKEN_CONTRACT_ADDRESS;
  const TimeVaultToken = await hre.ethers.getContractFactory("TimeVaultLock");

  const TimeVaultT= await TimeVaultToken.deploy(tvltokenAddress);

  await TimeVaultT.deployed();
  console.log(`Bank contract address: ${TimeVaultT.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });