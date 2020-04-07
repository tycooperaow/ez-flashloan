import Web3 from 'web3';
import { getAddressBalances } from 'eth-balance-checker/lib/web3';

const web3 = new Web3('http://localhost:8545');
const address = '0x4E83362442B8d1beC281594cEa3050c8EB01311C';
const tokens = ['0x0', '0x6B175474E89094C44Da98b954EedeAC495271d0F'];
getAddressBalances(web3, address, tokens).then(balances => {
  console.log(balances); // { "0x0": "100", "0x456...": "200" }
});
