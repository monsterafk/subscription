// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IEncryptedFileTokenCallbackReceiver  {
    function transferCancelled(uint256 tokenId) external;
    function transferFinished(uint256 tokenId) external;
    function transferFrauDetected(uint256 tokenId, bool approves) external;
} 