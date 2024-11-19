// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FiddlingNft} from "../src/FiddlingNft.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MintFiddlingNFT is Script {
    string public constant FIDDLE = "ipfs://QmTQZoFzvvUfSRriTZB1ofPDBX5JTeVCygSfNqyk6CnCXz";

    function run() external {
        address mostRecentlyDeployedFiddlingNft = DevOpsTools.get_most_recent_deployment("FiddlingNFT", block.chainid);
        mintNftOnFiddlingContract(mostRecentlyDeployedFiddlingNft);
    }

    function mintNftOnFiddlingContract(address contractAddress) public {
        vm.startBroadcast();
        FiddlingNft(contractAddress).mintNFT(FIDDLE);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        address mostRecentlyDeployedMoodNft = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintNftOnMoodContract(mostRecentlyDeployedMoodNft);
    }

    function mintNftOnMoodContract(address contractAddressMood) public {
        vm.startBroadcast();
        MoodNft(contractAddressMood).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script {
    function run() external {
        address mostRecentlyDeployedMoodNft = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        flipTheMoodNftOnContract(mostRecentlyDeployedMoodNft, 0);
    }

    function flipTheMoodNftOnContract(address contractAddressMood, uint256 tokenId) public {
        vm.startBroadcast();
        MoodNft(contractAddressMood).flipMood(tokenId);
        vm.stopBroadcast();
    }
}
