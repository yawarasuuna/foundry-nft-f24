// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {console2, Test} from "forge-std/Test.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DeployFiddlingNft} from "../../script/DeployFiddlingNft.s.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MintFiddlingNft, FlipMoodNft, MintMoodNft} from "../../script/Interactions.s.sol";
import {FiddlingNft} from "../../src/FiddlingNft.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract InteractionsTest is Test {
    FiddlingNft fiddlingNft;
    MoodNft moodNft;
    MintFiddlingNft mintFiddlingNft;
    MintMoodNft mintMoodNft;
    FlipMoodNft flipMoodNft;

    address mostRecentlyDeployedAddressFiddlingNft;
    address mostRecentlyDeployedAddressMoodNft;

    uint256 tokenIdToBeFlipped = 0;

    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCIsImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHRoZSBvd25lcnMgbW9vZC4iLCAiYXR0cmlidXRlcyI6W3sidHJhaXRfdHlwZSI6ICJtb29kaW5lc3MiLCJ2YWx1ZSI6IDEwMH1dLCJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBEOTRiV3dnZG1WeWMybHZiajBpTVM0d0lpQnpkR0Z1WkdGc2IyNWxQU0p1YnlJL1BnbzhjM1puSUhkcFpIUm9QU0l4TURJMGNIZ2lJR2hsYVdkb2REMGlNVEF5TkhCNElpQjJhV1YzUW05NFBTSXdJREFnTVRBeU5DQXhNREkwSWlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpUGdvZ0lEeHdZWFJvSUdacGJHdzlJaU16TXpNaUlHUTlJazAxTVRJZ05qUkRNalkwTGpZZ05qUWdOalFnTWpZMExqWWdOalFnTlRFeWN6SXdNQzQySURRME9DQTBORGdnTkRRNElEUTBPQzB5TURBdU5pQTBORGd0TkRRNFV6YzFPUzQwSURZMElEVXhNaUEyTkhwdE1DQTRNakJqTFRJd05TNDBJREF0TXpjeUxURTJOaTQyTFRNM01pMHpOekp6TVRZMkxqWXRNemN5SURNM01pMHpOeklnTXpjeUlERTJOaTQySURNM01pQXpOekl0TVRZMkxqWWdNemN5TFRNM01pQXpOeko2SWk4K0NpQWdQSEJoZEdnZ1ptbHNiRDBpSTBVMlJUWkZOaUlnWkQwaVRUVXhNaUF4TkRCakxUSXdOUzQwSURBdE16Y3lJREUyTmk0MkxUTTNNaUF6TnpKek1UWTJMallnTXpjeUlETTNNaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJdE1UWTJMall0TXpjeUxUTTNNaTB6TnpKNlRUSTRPQ0EwTWpGaE5EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ09UWWdNQ0EwT0M0d01TQTBPQzR3TVNBd0lEQWdNUzA1TmlBd2VtMHpOellnTWpjeWFDMDBPQzR4WXkwMExqSWdNQzAzTGpndE15NHlMVGd1TVMwM0xqUkROakEwSURZek5pNHhJRFUyTWk0MUlEVTVOeUExTVRJZ05UazNjeTA1TWk0eElETTVMakV0T1RVdU9DQTRPQzQyWXkwdU15QTBMakl0TXk0NUlEY3VOQzA0TGpFZ055NDBTRE0yTUdFNElEZ2dNQ0F3SURFdE9DMDRMalJqTkM0MExUZzBMak1nTnpRdU5TMHhOVEV1TmlBeE5qQXRNVFV4TGpaek1UVTFMallnTmpjdU15QXhOakFnTVRVeExqWmhPQ0E0SURBZ01DQXhMVGdnT0M0MGVtMHlOQzB5TWpSaE5EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ01DMDVOaUEwT0M0d01TQTBPQzR3TVNBd0lEQWdNU0F3SURrMmVpSXZQZ29nSUR4d1lYUm9JR1pwYkd3OUlpTXpNek1pSUdROUlrMHlPRGdnTkRJeFlUUTRJRFE0SURBZ01TQXdJRGsySURBZ05EZ2dORGdnTUNBeElEQXRPVFlnTUhwdE1qSTBJREV4TW1NdE9EVXVOU0F3TFRFMU5TNDJJRFkzTGpNdE1UWXdJREUxTVM0MllUZ2dPQ0F3SURBZ01DQTRJRGd1TkdnME9DNHhZelF1TWlBd0lEY3VPQzB6TGpJZ09DNHhMVGN1TkNBekxqY3RORGt1TlNBME5TNHpMVGc0TGpZZ09UVXVPQzA0T0M0MmN6a3lJRE01TGpFZ09UVXVPQ0E0T0M0Mll5NHpJRFF1TWlBekxqa2dOeTQwSURndU1TQTNMalJJTmpZMFlUZ2dPQ0F3SURBZ01DQTRMVGd1TkVNMk5qY3VOaUEyTURBdU15QTFPVGN1TlNBMU16TWdOVEV5SURVek0zcHRNVEk0TFRFeE1tRTBPQ0EwT0NBd0lERWdNQ0E1TmlBd0lEUTRJRFE0SURBZ01TQXdMVGsySURCNklpOCtDand2YzNablBnPT0ifQ==";

    function setUp() external {
        DeployFiddlingNft fiddlingDeployer = new DeployFiddlingNft();
        fiddlingNft = fiddlingDeployer.run();
        mostRecentlyDeployedAddressFiddlingNft = address(fiddlingNft);
        mintFiddlingNft = new MintFiddlingNft();

        // vm.mockCall(
        //     address(DevOpsTools),
        //     abi.encodeWithSelector(
        //         DevOpsTools.get_most_recent_deployment.selector,
        //         "FiddlingNft",
        //         block.chainid
        //     ),
        //     abi.encode(mostRecentlyDeployedAddressFiddlingNft)
        // );

        DeployMoodNft moodDeployer = new DeployMoodNft();
        moodNft = moodDeployer.run();
        mostRecentlyDeployedAddressMoodNft = address(moodNft);
        mintMoodNft = new MintMoodNft();
        flipMoodNft = new FlipMoodNft();
    }

    /*//////////////////////////////////////////////////////////////
                            MINTFIDDLINGNFT
    //////////////////////////////////////////////////////////////*/

    // function testRun() public {
    //     uint256 initialSupply = fiddlingNft.totalSupply();
    //     assertEq(initialSupply, 0, "Initial supply should be 0");

    //     mintFiddlingNft.run();

    //     uint256 newSupply = fiddlingNft.totalSupply();
    //     assertEq(newSupply, 1, "Minting failed: Token should be minted");

    //     uint256 mintedTokenId = newSupply - 1;
    //     string
    //         memory expectedMetadata = "ipfs://QmTQZoFzvvUfSRriTZB1ofPDBX5JTeVCygSfNqyk6CnCXz";
    //     assertEq(
    //         fiddlingNft.tokenURI(mintedTokenId),
    //         expectedMetadata,
    //         "Metadata URL should match"
    //     );
    // }

    function testScriptMintFiddlingNft() public {
        uint256 tokenId = fiddlingNft.getTokenCounter();
        mintFiddlingNft.mintNftOnFiddlingContract(address(fiddlingNft));
        assertEq(fiddlingNft.getTokenCounter(), tokenId + 1);
    }

    /*//////////////////////////////////////////////////////////////
                              MINTMOODNFT
    //////////////////////////////////////////////////////////////*/

    function testScriptMintMoodNft() public {
        uint256 tokenId = moodNft.getTokenCounter();

        mintMoodNft.mintNftOnMoodContract(address(moodNft));
        assertEq(moodNft.getTokenCounter(), tokenId + 1);
    }

    /*//////////////////////////////////////////////////////////////
                              FLIPMOODNFT
    //////////////////////////////////////////////////////////////*/

    function testScriptFlipMoodNft() public {
        mintMoodNft.mintNftOnMoodContract(address(moodNft));
        flipMoodNft.flipTheMoodNftOnContract(address(moodNft), tokenIdToBeFlipped);
        string memory actualSadTokenURI = moodNft.tokenURI(0);
        string memory expectedSadTokenURI = SAD_SVG_URI;

        assertEq(keccak256(abi.encodePacked(actualSadTokenURI)), keccak256(abi.encodePacked(expectedSadTokenURI)));
    }
}
