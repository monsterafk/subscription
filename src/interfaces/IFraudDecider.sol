// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IFraudDecider {
    function decide(
        uint256 tokenId,
        string calldata cid,
        bytes calldata publicKey,
        bytes calldata privateKey,
        bytes calldata encryptedPassword
    ) external returns(bool, bool);
}