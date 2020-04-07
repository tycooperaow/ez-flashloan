"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
exports.__esModule = true;
var web3_1 = __importDefault(require("web3"));
var web3_2 = require("eth-balance-checker/lib/web3");
var web3 = new web3_1["default"]('http://localhost:8545');
//mainet account with lots of ETH and DAI
var accountAddress = '0x4E83362442B8d1beC281594cEa3050c8EB01311C';
var contractAddress = '0xD7206a08e46a786c654F2c433C9E6411796B92e4';
var tokens = ['0x6B175474E89094C44Da98b954EedeAC495271d0F'];


const foo = async () => {
  try {
      console.log("DAI balance of borrower account: " + accountAddress)
      await web3_2.getAddressBalances(web3, accountAddress, tokens).then(function (balances) {
          console.log(balances); // { "0x0": "100", "0x456...": "200" }
      });
      console.log("DAI balance of flashloan contract: " + contractAddress)
      await web3_2.getAddressBalances(web3, contractAddress, tokens).then(function (balances) {
          console.log(balances); // { "0x0": "100", "0x456...": "200" }
      });
  } catch (err) {
      console.log(err.message);
  }
}


foo();
