// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CalldataReverser is Test {
    address public rev;

    function setUp() public {
        rev = HuffDeployer.deploy("../src/rev-calldata-chunks");
        // log code length
        console2.log("code length", rev.code.length);
    }

    function testRev32() public {
        bytes memory data = "0123456789abcdef0123456789abcdef";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        assertEq(ret, "fedcba9876543210fedcba9876543210");
    }

    function testRev64() public {
        // actually a palindrome
        bytes
            memory data = "0123456789abcdef0123456789abcdeffedcba9876543210fedcba9876543210";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        assertEq(ret, data);
    }

    function testRevVerbose() public {
        bytes
            memory data = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        console2.log("len(ret) =", ret.length);
        console2.log("ret =", string(ret));
        console2.logBytes(ret);
    }
}
