// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract EncodingInPractice {
    function encodeAnythingFromNumbers() public pure returns (bytes memory) {
        bytes memory anyNumber = abi.encode(92834);
        return anyNumber;
    }

    function encodeAnythingFromStringsToo() public pure returns (bytes memory) {
        bytes memory anyString = abi.encode("whatever");
        return anyString;
    }

    function encodePackedSavesGasButCantCallFunction()
        public
        pure
        returns (bytes memory)
    {
        bytes memory compressionInAction = abi.encodePacked("A string");
        return compressionInAction;
    }

    function decodeMagic() public pure returns (string memory) {
        string memory decodedTheEncode = abi.decode(
            encodeAnythingFromStringsToo(),
            (string)
        );
        return decodedTheEncode;
    }

    function amalgamation() public pure returns (bytes memory) {
        bytes memory fusion = abi.encode(
            "What should I amalgamate? ",
            "Whatever you might want"
        );
        return fusion;
    }

    function sunder() public pure returns (string memory, string memory) {
        (string memory fission, string memory scission) = abi.decode(
            amalgamation(),
            (string, string)
        );
        return (fission, scission);
    }

    function amalgamationPacked() public pure returns (bytes memory) {
        bytes memory fusion = abi.encodePacked("Stuff here ", "and There");
        return fusion;
    }

    function sunderPackedDoesNotWork()
        public
        pure
        returns (string memory, string memory)
    {
        (string memory fission, string memory scission) = abi.decode(
            amalgamation(),
            (string, string)
        );
        return (fission, scission);
    }

    function castMultiStringsInstead() public pure returns (string memory) {
        string memory fission = string(amalgamationPacked());
        return fission;
    }
}
