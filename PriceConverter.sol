// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import price feed code from npm/github
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * libraries cannot have state variables and cannot send ether
 */
library PriceConverter
{
    /**
     * fetches latest ethereum price in terms of wei(to avoid working with floats and getting rounding
     * errors)
     */
    function getPrice() internal view returns (uint)
    {
        // ABI(Application binary interface)
        // Address - 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        // AggregatorV3Interface is used for consuming price data(it fetches price data from an oracle network)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (
            // the comments could be left out, just included them here to understand what is being returned
            /* uint80 roundID */,
            int price, // not uint since some asset prices could be negative
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData();
        // price feed will return the price in usd
        // we want to avoid float math at all cost because it will result in rounding errors so we convert the
        // usd amount to wei and return the result
        return uint(price * 1e18); // price of ethereum in terms of wei. To get equivalent usd amount divide by 1e18
    }

    /**
     * fetches the price feed version
     */
    function getVersion() internal view returns (uint256)
    {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    /**
     * converts ethereum to usd
     * ethAmount: ethereum amount in terms of wei
     * we work with whole numbers to avoid losing precision
     *
     * TODO: bug: if amount < minAmount, still goes through when it shouldn't
     */
    function getConversionRate(uint ethAmount) internal view returns (uint)
    {
        uint ethPrice = getPrice();
        // always perform multiplication & addition first before dividing
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}