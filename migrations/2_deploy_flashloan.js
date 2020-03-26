let Flashloan = artifacts.require("Flashloan")

module.exports = async function (deployer, network, account) {
    try {
        await deployer.deploy(Flashloan, {from: "0x4E83362442B8d1beC281594cEa3050c8EB01311C"})
    } catch (e) {
        console.log(`Error in migration: ${e.message}`)
    }
}
