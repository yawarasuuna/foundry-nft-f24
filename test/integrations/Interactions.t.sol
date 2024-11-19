// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {console2, Test} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {FiddlingNft, FlipMoodNft, MintMoodNft} from "../../script/Interactions.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract InteractionsTest is Test {
    FlipMoodNft private flipMoodNft;
    address private MINTER = makeAddr("minter");

    function setUp() external {
        flipMoodNft = new FlipMoodNft();
    }

    function testFlipTokenToSadWhenUsingInteractions() public {
        vm.prank(MINTER);
        flipMoodNft.flipTheMoodNftOnContract(address(moodNft), 0);

        console2.log(moodNft.tokenURI(0));
        console2.log(SAD_SVG_URI);

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}
