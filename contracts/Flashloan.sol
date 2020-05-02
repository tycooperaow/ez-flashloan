pragma solidity ^0.5.0;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";

interface DaiToken{
  function approve(address usr, uint wad) external returns (bool);
}

interface KncToken{
  function approve(address usr, uint wad) external returns (bool);
}

interface UniswapExchange{
  // Trade ERC20 to ERC20
  function tokenToTokenSwapInput(
    uint256 tokens_sold,
    uint256 min_tokens_bought,
    uint256 min_eth_bought,
    uint256 deadline,
    address token_addr
  ) external returns (uint256 tokens_bought);
}


contract Flashloan is FlashLoanReceiverBase {

    //Events
    event beforeBorrow(address _reserve, uint256 _amount, uint256 _eth, uint256 _dai);
    event borrowMade(address _reserve, uint256 _amount, uint256 _eth, uint256 _dai);
    event daiApproved(string _message);
    event uniswapDone(string _message);
    event borrowReturned(address _reserve, uint256 _amount, uint256 _eth, uint256 _dai);

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");
        emit borrowMade(address(this), _amount, address(this).balance, getBalanceInternal(address(this), address(0x6B175474E89094C44Da98b954EedeAC495271d0F)));

        //
        // do your thing here
        //

        DaiToken daiToken = DaiToken(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        daiToken.approve(address(this),_amount);
        emit daiApproved('DAI was approved');

        //making DAI to KNC swap
        uint256 DEADLINE = block.timestamp + 300;
        UniswapExchange uniswapExchange = UniswapExchange(0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667);

        uniswapExchange.tokenToTokenSwapInput(_amount, 1, 1, DEADLINE, address(0xdd974D5C2e2928deA5F71b9825b8b646686BD200));
        //javascript code from swap-dai-for-knc.js:69
        //result = await exchangeContract.methods.tokenToTokenSwapInput(DAI_TO_SWAP, MIN_TOKENS, MIN_ETH, DEADLINE, KNC_ADDRESS).send({from : SETTINGS.from, gasLimit : 4000000})
        emit uniswapDone('Uniswap is done');


        // Time to transfer the funds back
        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
        emit borrowReturned(address(this), _amount, address(this).balance, getBalanceInternal(address(this), address(0x6B175474E89094C44Da98b954EedeAC495271d0F)));
    }

    function flashloan() public  {
        bytes memory data = "";
        uint amount = 100 ether;
        address asset = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); // mainnet DAI

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        emit beforeBorrow(address(this), amount, address(this).balance, getBalanceInternal(address(this), asset));
        lendingPool.flashLoan(address(this), asset, amount, data);
    }
}
