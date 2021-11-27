const main = async () => {
    console.log("Starting deploy");
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    console.log("Deploying contract ..");
    const nftContract = await nftContractFactory.deploy();
    console.log("Deploying contract ...");
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT();
    await txn.wait();

    txn = await nftContract.makeAnEpicNFT();
    await txn.wait()
}

const runMain = async() => {
    try {
        await main();
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();

