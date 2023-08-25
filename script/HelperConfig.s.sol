// SPDX-License-Identifier: MIT

//1. Deploy mocks when we are on a local anvil chain
//2. Keep track of contract address across different chains
//Sepolia - ETH/USD
//Mainnet - ETH/USD

pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol"; //needed of vm broadcast
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local anvil chain we deploy mocks
    //otherwise grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; //Eth /usd price feed address
    }

    constructor() {
        if (block.chainid == 11155111)
            activeNetworkConfig = getSepoliaEthConfig();
        else if (block.chainid == 1)
            activeNetworkConfig = getMainnetEthConfig();
        else activeNetworkConfig = getOrCreateAnvilEthConfig();
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    uint8 public constant DECIMALS = 8; //constants for mock price feed contract
    int256 public constant INITIAL_PRICE = 2000e8;

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0))
            //if we have previously deployed then return that
            return activeNetworkConfig;
        //1.deploy mock contract
        //2.return mock addresses
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory AnvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return AnvilConfig;
    }
}
