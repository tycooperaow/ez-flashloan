let FlashloanMock = artifacts.require("FlashloanMock")

module.exports = async function (deployer) {
    try {
        await deployer.deploy(FlashloanMock)
    } catch (e) {
        console.log(`Error in migration: ${e.message}`)
    }
}
