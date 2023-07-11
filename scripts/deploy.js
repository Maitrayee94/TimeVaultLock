const hre = require("hardhat");


async function main() {
  
  const TimeVaultToken = await hre.ethers.getContractFactory("TimeVaultLock");

  const TimeVaultT= await TimeVaultToken.deploy();

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