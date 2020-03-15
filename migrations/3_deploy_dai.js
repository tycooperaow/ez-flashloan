let Dai = artifacts.require("Dai")

module.exports = async function (deployer) {
    try {
        await deployer.deploy(Dai)
    } catch (e) {
        console.log(`Error in migration: ${e.message}`)
    }
}
