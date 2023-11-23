// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
0. message to sign
1. hash[message]
2. sign(hash(mesage),private key) | offchain
3. ecrecover(hash(message),signature) == signer
*/
contract VerifySig{
    /**
    * _signer 签名人地址
    * _message 消息原文
    * _sig 签名的结果
    */
    function verify(address _signer, string memory _message, bytes memory _sig) external pure returns(bool){
        bytes32 messageHash = getMessageHash(_message);
        // hash 后的结果
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);


        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(string memory _message) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32){
         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",_messageHash));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns(address){
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(_sig);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /// signature methods.
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65,"invalid signatrue length");

        assembly {
            // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
            // second 32 bytes.
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }
}