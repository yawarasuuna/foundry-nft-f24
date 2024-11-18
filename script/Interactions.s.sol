// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FiddlingNft} from "../src/FiddlingNft.sol";


contract MintFiddlingNFT is Script {
    string public constant FIDDLE = "ipfs://QmTQZoFzvvUfSRriTZB1ofPDBX5JTeVCygSfNqyk6CnCXz";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FiddlingNFT", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        FiddlingNft(contractAddress).mintNFT(FIDDLE);

        vm.stopBroadcast();
    }
}
