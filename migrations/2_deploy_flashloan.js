let Flashloan = artifacts.require("Flashloan")

module.exports = async function (deployer, network, account) {
    try {
        await deployer.deploy(Flashloan, {from: "0x92028aBF53448A322DA87C327000CedbdAd203f0"})
    } catch (e) {
        console.log(`Error in migration: ${e.message}`)
    }
}
