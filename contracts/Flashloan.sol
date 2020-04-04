pragma solidity ^0.5.15;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";

contract Flashloan is FlashLoanReceiverBase {
    address daiAddress = address(0x03e972809c6f93AeE4E7fb784ff96c0E9489F60c);

    //Events
    event borrowMade(address _reserve, uint256 _amount, uint256 _value);

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // do your thing here
        //

        emit borrowMade(_reserve, _amount, address(this).balance);

        // Time to transfer the funds back
        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    function flashloan() public  {
        bytes memory data = "";
        uint amount = 1 ether;
        address asset = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); // mainnet DAI
        //address asset = daiAddress; // local testnet DAI !! it changes at every migrate

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), asset, amount, data);
    }
}
