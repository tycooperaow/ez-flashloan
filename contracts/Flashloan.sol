pragma solidity ^0.5.15;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";

contract Flashloan is FlashLoanReceiverBase {

    //Events
    event beforeBorrow(address _reserve, uint256 _amount, uint256 _eth, uint256 _dai);
    event requireValues(uint256 _amount, uint256 _amountInternal);
    event borrowMade(address _reserve, uint256 _amount, uint256 _eth, uint256 _dai);
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
        emit requireValues(_amount, getBalanceInternal(address(this), _reserve));

        //
        // do your thing here
        //


        emit borrowMade(address(this), _amount, address(this).balance, getBalanceInternal(address(this), address(0x6B175474E89094C44Da98b954EedeAC495271d0F)));

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
