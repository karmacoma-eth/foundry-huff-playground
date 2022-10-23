// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CalldataReverser is Test {
    address public rev;

    function setUp() public {
        rev = HuffDeployer.deploy("../src/rev-calldata-chunks");
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

    function testRev96() public {
        bytes
            memory data = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccccccccc";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        assertEq(
            ret,
            "ccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        );
    }

    function testRev8() public {
        bytes memory data = "12345678";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        assertEq(ret, "87654321");
    }

    function testRev48() public {
        bytes memory data = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        assertEq(ret, "bbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    }

    function testRevEmpty() public {
        bytes memory data = "";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        assertEq(ret, "");
    }

    function testRevVerbose() public {
        bytes memory data = "0123456789abcdef0123456789abcdef";
        (bool success, bytes memory ret) = rev.call(data);

        assertTrue(success);
        console2.log("len(ret) =", ret.length);
        console2.log("ret =", string(ret));
        console2.logBytes(ret);
    }
}
