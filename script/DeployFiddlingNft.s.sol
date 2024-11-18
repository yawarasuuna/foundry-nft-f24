// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FiddlingNft} from "../src/FiddlingNft.sol";

contract DeployFiddlingNft is Script {
    function run() external returns (FiddlingNft) {
        vm.startBroadcast();
        FiddlingNft fiddlingNFT = new FiddlingNft();
        vm.stopBroadcast();
        return fiddlingNFT;
    }
}
