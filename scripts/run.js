const main = async () => {
  const [owner, randoPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  let waveCount;
  waveCount = await waveContract.getTotalWaves();
  console.log("Total waves:", waveCount.toNumber());
  
  
  let waveTxn = await waveContract.wave("A message!");
  await waveTxn.wait();
  
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));
  
  waveTxn = await waveContract.connect(randoPerson).wave('Hello there');
  await waveTxn.wait();
  
  waitCount = await waveContract.getTotalWaves();
  console.log("Total waves:", waitCount.toNumber());
  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  console.log("Spam wave should fail!");
  waveTxn = await waveContract.connect(randoPerson).wave('Hello there');
  await waveTxn.wait();
};  

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();