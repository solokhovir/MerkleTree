// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Tree {
    bytes32[] public hashes;
    string[4] heroes = ["Sherlock", "John", "Mary", "Lestrade"];

    constructor() {
        for(uint i = 0; i < heroes.length; i++) {
            hashes.push(keccak256(abi.encodePacked(heroes[i])));
        }

        uint n = heroes.length;
        uint offset = 0;
        while (n > 0) {
            for (uint i = 0; i < n - 1; i+= 2) {
                bytes32 newHash = keccak256(abi.encodePacked(
                    hashes[i + offset], hashes[i + offset + 1]
                ));
                hashes.push(newHash);
            }
            offset += n;
            n = n / 2;
        }
    }

    function verify(bytes32 root, bytes32 leaf, uint index, bytes32[] memory proof) public pure returns(bool) {
        bytes32 hash = leaf;
        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(
                    hash, proofElement
                ));
            } else {
                hash = keccak256(abi.encodePacked(
                    proofElement, hash
                ));
            }
            index = index / 2;
        }
        return hash == root;
    } 

    function getRoot() public view returns(bytes32) {
        return hashes[hashes.length - 1];
    }
}