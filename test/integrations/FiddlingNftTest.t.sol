// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {console2, Test} from "forge-std/Test.sol";
import {DeployFiddlingNft} from "../../script/DeployFiddlingNft.s.sol";
import {FiddlingNft} from "../../src/FiddlingNft.sol";

contract FiddlingNftTest is Test {
    DeployFiddlingNft public deployer;
    FiddlingNft public fiddlingNft;
    address public MINTER = makeAddr("minter");
    string public constant FIDDLE =
        "ipfs://bafybeicljm2g35llbfb2ubhblhdyduou6inrry5qyec6felorgnjol3hfe.ipfs.dweb.link?filename=Fiddle1.json";

    function setUp() public {
        deployer = new DeployFiddlingNft();
        fiddlingNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Fiddle";
        string memory actualName = fiddlingNft.name();
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "FIDDL";
        string memory actualSymbol = fiddlingNft.symbol();
        assert(
            keccak256(abi.encodePacked(expectedSymbol)) ==
                keccak256(abi.encodePacked(actualSymbol))
        );
    }

    modifier MinterMintsNft() {
        vm.prank(MINTER);
        fiddlingNft.mintNFT(FIDDLE);
        _;
    }

    function testCanMindAndHaveABalance() public MinterMintsNft {
        assert(fiddlingNft.balanceOf(MINTER) == 1);
        assert(
            keccak256(abi.encodePacked(FIDDLE)) ==
                keccak256(abi.encodePacked(fiddlingNft.tokenURI(0)))
        );
    }

    function testOwnerOfNftIsMinter() public MinterMintsNft {
        assert(fiddlingNft.ownerOf(0) == MINTER);
    }
}
