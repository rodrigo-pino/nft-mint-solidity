const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT();
    await txn.wait();

    txn = await nftContract.makeAnEpicNFT();
    await txn.wait()

    let event = nftContract.getTotalNFTMinted();

    nftContract.on("TotalNFTsMinted", (curr, tot) => {
        console.log("(current, total) = ", curr.toNumber(), ",", tot.toNumber());
    });
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
