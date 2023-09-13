// SPDX-License-Identifier: BSD
pragma solidity ^0.8.4;

import {DripGradeClone} from "src/DripGradeClone.sol";
import {DripGradeCloneFactory} from "src/DripGradeCloneFactory.sol";
import {IDrip} from "src/IDrip.sol";
import "forge-std/Test.sol";

contract DripGradeCloneTest is Test {
    DripGradeCloneFactory internal factory;
    DripGradeClone internal clone;

    string basepath = "./test/drip-grades/";

    function setUp() public {
        DripGradeClone implementation = new DripGradeClone();
        factory = new DripGradeCloneFactory(implementation);

        bytes memory data = vm.envBytes("calldata");
        clone = factory.createClone(data);
    }

    /// -----------------------------------------------------------------------
    /// Gas benchmarking
    /// -----------------------------------------------------------------------
    function testGasCreate10000() public {
        bytes memory data = vm.envBytes("calldata");
        factory.createClone(data);
    }

    function testGasDripGradeId0() public view {
        clone.dripGrade(uint256(0));
    }

    function testGasDripGradeId9999() public view {
        clone.dripGrade(uint256(9999));
    }

    /// Correctness
    /// -----------------------------------------------------------------------

    function testDripGradeAll() public {
        for (uint256 tokenid = 0; tokenid < 10000; tokenid++) {
            string memory data = vm.readFile(
                string.concat(basepath, vm.toString(tokenid))
            );

            IDrip.Grade result = clone.dripGrade(tokenid);
            if (result == IDrip.Grade.normal) {
                assertEq(data, string("normal"));
            } else if (result == IDrip.Grade.c_drip) {
                assertEq(data, string("c-drip"));
            } else if (result == IDrip.Grade.b_drip) {
                assertEq(data, string("b-drip"));
            } else if (result == IDrip.Grade.a_drip) {
                assertEq(data, string("a-drip"));
            } else if (result == IDrip.Grade.s_drip) {
                assertEq(data, string("s-drip"));
            } else if (result == IDrip.Grade.ss_drip) {
                assertEq(data, string("ss-drip"));
            } else {
                revert("unknown drip grade");
            }
        }
    }

    function testFuzzDripGrade(uint256 tokenid) public {

        if (tokenid > 9999) {
            tokenid = bound(tokenid, 0, 9999);
        }
        string memory data = vm.readFile(
            string.concat(basepath, vm.toString(tokenid))
        );
        IDrip.Grade result = clone.dripGrade(tokenid);
        if (result == IDrip.Grade.normal) {
            assertEq(data, string("normal"));
        } else if (result == IDrip.Grade.c_drip) {
            assertEq(data, string("c-drip"));
        } else if (result == IDrip.Grade.b_drip) {
            assertEq(data, string("b-drip"));
        } else if (result == IDrip.Grade.a_drip) {
            assertEq(data, string("a-drip"));
        } else if (result == IDrip.Grade.s_drip) {
            assertEq(data, string("s-drip"));
        } else if (result == IDrip.Grade.ss_drip) {
            assertEq(data, string("ss-drip"));
        } else {
            revert("unknown drip grade");
        }
    }

    function testGregsMilady() public view {
        assert(clone.dripGrade(uint256(3736)) == IDrip.Grade.ss_drip);
    }

    /// -----------------------------------------------------------------------
    /// Reverts
    /// -----------------------------------------------------------------------

    function testFuzzRevert(uint256 tokenid) public {
        if (tokenid <= 9999) {
            uint256 maxvalue;
            assembly {
                maxvalue := sub(0, 1)
            }
            tokenid = bound(tokenid, 10000, maxvalue);
        }
        vm.expectRevert();
        clone.dripGrade(tokenid);
    }

}
