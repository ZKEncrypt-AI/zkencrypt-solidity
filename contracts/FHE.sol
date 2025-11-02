// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

type euint8 is uint256;
type euint16 is uint256;
type euint32 is uint256;
type euint64 is uint256;
type ebool is uint256;

library FHE {
    // Convert encrypted bytes to euint types
    function asEuint8(bytes memory input) internal pure returns (euint8) {
        return euint8.wrap(uint256(bytes32(input)));
    }

    function asEuint16(bytes memory input) internal pure returns (euint16) {
        return euint16.wrap(uint256(bytes32(input)));
    }

    function asEuint32(bytes memory input) internal pure returns (euint32) {
        return euint32.wrap(uint256(bytes32(input)));
    }

    function asEuint64(bytes memory input) internal pure returns (euint64) {
        return euint64.wrap(uint256(bytes32(input)));
    }

    function asEbool(bool input) internal pure returns (ebool) {
        return ebool.wrap(input ? 1 : 0);
    }

    // Homomorphic Addition
    function add(euint64 a, euint64 b) internal pure returns (euint64) {
        return euint64.wrap(euint64.unwrap(a) + euint64.unwrap(b));
    }

    // Homomorphic Subtraction
    function sub(euint64 a, euint64 b) internal pure returns (euint64) {
        return euint64.wrap(euint64.unwrap(a) - euint64.unwrap(b));
    }

    // Homomorphic Multiplication
    function mul(euint64 a, euint64 b) internal pure returns (euint64) {
        return euint64.wrap(euint64.unwrap(a) * euint64.unwrap(b));
    }

    // Homomorphic Division
    function div(euint64 a, euint64 b) internal pure returns (euint64) {
        require(euint64.unwrap(b) != 0, "Division by zero");
        return euint64.wrap(euint64.unwrap(a) / euint64.unwrap(b));
    }

    // Homomorphic Equality Check
    function eq(euint64 a, euint64 b) internal pure returns (ebool) {
        return ebool.wrap(euint64.unwrap(a) == euint64.unwrap(b) ? 1 : 0);
    }

    // Homomorphic Not-Equal Check
    function ne(euint64 a, euint64 b) internal pure returns (ebool) {
        return ebool.wrap(euint64.unwrap(a) != euint64.unwrap(b) ? 1 : 0);
    }

    // Homomorphic Less-Than
    function lt(euint64 a, euint64 b) internal pure returns (ebool) {
        return ebool.wrap(euint64.unwrap(a) < euint64.unwrap(b) ? 1 : 0);
    }

    // Homomorphic Greater-Than
    function gt(euint64 a, euint64 b) internal pure returns (ebool) {
        return ebool.wrap(euint64.unwrap(a) > euint64.unwrap(b) ? 1 : 0);
    }

    // Homomorphic Conditional Select
    function select(ebool condition, euint64 ifTrue, euint64 ifFalse) internal pure returns (euint64) {
        if (ebool.unwrap(condition) == 1) {
            return ifTrue;
        }
        return ifFalse;
    }

    // Re-encrypt for specific user
    function reencrypt(euint64 value, address user) internal pure returns (bytes memory) {
        // Mock implementation - in production, this would use actual FHE re-encryption
        return abi.encodePacked(value, user);
    }

    // Decrypt value (requires permission)
    function decrypt(ebool value) internal pure returns (bool) {
        return ebool.unwrap(value) == 1;
    }

    function decrypt(euint64 value) internal pure returns (uint64) {
        return uint64(euint64.unwrap(value));
    }
}
