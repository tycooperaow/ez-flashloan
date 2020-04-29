const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const factoryABI = [{"name":"NewExchange","inputs":[{"type":"address","name":"token","indexed":true},{"type":"address","name":"exchange","indexed":true}],"anonymous":false,"type":"event"},{"name":"initializeFactory","outputs":[],"inputs":[{"type":"address","name":"template"}],"constant":false,"payable":false,"type":"function","gas":35725},{"name":"createExchange","outputs":[{"type":"address","name":"out"}],"inputs":[{"type":"address","name":"token"}],"constant":false,"payable":false,"type":"function","gas":187911},{"name":"getExchange","outputs":[{"type":"address","name":"out"}],"inputs":[{"type":"address","name":"token"}],"constant":true,"payable":false,"type":"function","gas":715},{"name":"getToken","outputs":[{"type":"address","name":"out"}],"inputs":[{"type":"address","name":"exchange"}],"constant":true,"payable":false,"type":"function","gas":745},{"name":"getTokenWithId","outputs":[{"type":"address","name":"out"}],"inputs":[{"type":"uint256","name":"token_id"}],"constant":true,"payable":false,"type":"function","gas":736},{"name":"exchangeTemplate","outputs":[{"type":"address","name":"out"}],"inputs":[],"constant":true,"payable":false,"type":"function","gas":633},{"name":"tokenCount","outputs":[{"type":"uint256","name":"out"}],"inputs":[],"constant":true,"payable":false,"type":"function","gas":663}];

module.exports = async function (callback) {

      //creating Uniswap Factory instance, we connect it to address from mainnet
      console.log("Creating instance of Uniswap Factory contract");
      const factoryAddress = "0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95";
      const factoryContract = new web3.eth.Contract(factoryABI, factoryAddress);
      //console.log(factoryContract);

      //getting Uniswap exchange address for KNC
      console.log('Getting uniswap KNC Exchange address')
      const tokenAddress = "0xdd974d5c2e2928dea5f71b9825b8b646686bd200";
      const exchangeAddress = await factoryContract.methods.getExchange(tokenAddress).call();
      console.log('Uniswap exchange address for KNC:');
      console.log(exchangeAddress);

}
