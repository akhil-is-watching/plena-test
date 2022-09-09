const hre = require("hardhat");

async function main() {

  const lockedAmount = hre.ethers.utils.parseEther("1");

  const TestSwapLend = await hre.ethers.getContractFactory("TestSwapLend");
  // Assuming the passed parameters have the correct value initialized
  const tsl = await TestSwapLend.deploy(comet, router, usdc, usdt);
  await tsl.deployed();

  console.log(
    `TSL deployed to ${tsl.address}`
  );

  // Assumin a contract instance usdc exists and initiating transfer.
  await usdc.transfer(tsl.address, lockedAmount);

  await tsl.complete()
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
